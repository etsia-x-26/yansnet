import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../error/error_handler.dart';

class ApiClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  final String _baseUrl = 'https://yansnetapi.enlighteninnovation.com';

  final _tokenExpirationController = StreamController<void>.broadcast();
  Stream<void> get tokenExpirationStream => _tokenExpirationController.stream;
  
  bool _isRefreshing = false;
  Completer<String?> _refreshCompleter = Completer<String?>();

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // If the failed request was already for refresh, don't retry -> logout
          if (e.requestOptions.path.contains('/auth/refresh')) {
             await _performLogout();
             return handler.next(e);
          }

          // If a refresh is already in progress, wait for it to complete
          if (_isRefreshing) {
            try {
              final newToken = await _refreshCompleter.future;
              if (newToken != null) {
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                try {
                  final retryResponse = await _dio.fetch(opts);
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  return handler.next(retryError as DioException);
                }
              }
            } catch (_) {
              // If refresh failed, fall through to logout
            }
             await _performLogout();
             _tokenExpirationController.add(null);
             return handler.next(e);
          }

          _isRefreshing = true;
          _refreshCompleter = Completer<String?>();

          try {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              final dioRefresh = Dio(BaseOptions(
                baseUrl: _baseUrl,
                headers: {'Content-Type': 'application/json'},
              ));
              
              final refreshResponse = await dioRefresh.post('/auth/refresh', data: {
                'refreshToken': refreshToken,
              });

              if (refreshResponse.statusCode == 200) {
                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];

                if (newAccessToken != null) {
                  await _storage.write(key: 'auth_token', value: newAccessToken);
                }
                if (newRefreshToken != null) {
                   await _storage.write(key: 'refresh_token', value: newRefreshToken);
                }
                
                _refreshCompleter.complete(newAccessToken);
                _isRefreshing = false;

                // Retry original request
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccessToken';
                try {
                  final retryResponse = await _dio.fetch(opts);
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  return handler.next(retryError as DioException);
                }
              }
            }
          } catch (refreshError) {
            print('Token refresh failed: $refreshError');
            _refreshCompleter.completeError(refreshError);
          } finally {
            _isRefreshing = false;
             if (!_refreshCompleter.isCompleted) {
                 _refreshCompleter.complete(null);
             }
          }

          // If we reach here, refresh failed -> Logout
          await _performLogout();
          _tokenExpirationController.add(null);
        }

        final errorMessage = ErrorHandler.getErrorMessage(e);
        return handler.next(
          DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: e.type,
            error: errorMessage,
            message: errorMessage,
          ),
        );
      },
    ));
  }

  Future<void> _performLogout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_data');
  }

  Dio get dio => _dio;
  FlutterSecureStorage get storage => _storage;
  
  void dispose() {
    _tokenExpirationController.close();
  }
}

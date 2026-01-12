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
        // Log the error
        // print('DioError: ${e.message}');
        
        // Handle 401 Unauthorized
        if (e.response?.statusCode == 401) {
          // If the failed request was already for refresh, don't retry -> logout
          if (e.requestOptions.path.contains('/auth/refresh')) {
             await _performLogout();
             return handler.next(e);
          }

          // Try to refresh token
          final refreshToken = await _storage.read(key: 'refresh_token');
          
          if (refreshToken != null) {
            try {
              // Create a temporary Dio instance to avoid interceptor loops
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

                // Retry the original request with new token
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccessToken';
                
                try {
                  final retryResponse = await _dio.fetch(opts);
                  return handler.resolve(retryResponse);
                } catch (retryError) {
                  return handler.next(retryError as DioException);
                }
              }
            } catch (refreshError) {
              // Refresh failed
              print('Token refresh failed: $refreshError');
            }
          }
          
          // If we reach here, refresh failed or no token -> Logout
          await _performLogout();
          _tokenExpirationController.add(null);
        }

        // Use ErrorHandler to get a user-friendly message for other errors
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

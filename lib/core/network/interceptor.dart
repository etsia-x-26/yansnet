import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yansnet/core/network/dio.dart';
import 'package:yansnet/core/utils/pref_utils.dart';

class TokenInterceptor extends QueuedInterceptor{
  String? accessToken;

  Future<SharedPreferences> instance = SharedPreferences.getInstance();

  @override
  Future<void> onRequest( RequestOptions options,
      RequestInterceptorHandler handler,) async{
    if(accessToken == null){
      accessToken = await PrefUtils().getAuthToken();

      if(accessToken == null){
        return handler.next(options);
      }
    }

    if(options.path != '/auth/login'){
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }


  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.type == DioExceptionType.badResponse &&
        err.response?.statusCode == 403 ||
        err.response?.statusCode == 401) {
      final options = err.response?.requestOptions;

      // If the token has been updated, repeat directly.
      if (options?.headers['Authorization'] != null &&
          !options!.headers['Authorization']
              .toString()
              .contains(accessToken!)) {
        options.headers['Authorization'] = 'Bearer ${accessToken!}';
        //repeat
        await Dio().fetch<void>(options).then(
              (r) => handler.resolve(r),
          onError: (DioException e) => handler.reject(e),
        );
        return;
      }

      final refreshDio = Dio(
        BaseOptions(baseUrl: 'https://dmp.dme.:9443/zeb-api'),
      );
      // Add the Api method to get the token on tsystemshe server
      await refreshDio
          .post('/auth/login', options: defaultOptions)
          .then((value) async {
        // need to modify this
        accessToken = value.data['token'] as String;
        await PrefUtils().setAuthToken(accessToken!);
        options?.headers['Authorization'] = 'Bearer ${accessToken!}';

        //repeat
        await Dio().fetch<void>(options!).then(
              (r) => handler.resolve(r),
          onError: (DioException e) => handler.reject(e),
        );
      }).onError((error, stackTrace) {
        handler.next(error! as DioException);
      });

      return;
    }

    return handler.next(err);
  }
}
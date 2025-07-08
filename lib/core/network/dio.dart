
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:yansnet/core/network/interceptor.dart';

Options defaultOptions = Options(
  responseType: ResponseType.json,
  contentType: Headers.jsonContentType,
  headers: {
    'Accept-language': 'en',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
);

CacheOptions cacheOptions = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),
  policy: CachePolicy.forceCache,
);

const apiBaseUrl = 'https://localhost:8080';
const imageBaseUrl = 'https://localhost:8080';

Dio http = Dio(
  BaseOptions(
    baseUrl: apiBaseUrl,
    contentType: 'application/json'
  ),
)..interceptors.addAll(
  [
    TokenInterceptor(),
    DioCacheInterceptor(
      options: cacheOptions
    ),
  ]
);

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:yansnet/conversation/api/channels_client.dart';
import 'package:yansnet/conversation/api/channels_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // --- Dio Setup ---
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://yansnetapi.enlighteninnovation.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: Replace with your actual token from a secure storage
        const token = 'YOUR_STATIC_TOKEN_HERE';
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));

    return dio;
  });

  // --- API Clients ---
  // The client now gets the pre-configured Dio instance.
  getIt.registerLazySingleton(() => ChannelsClient(getIt<Dio>()));

  // --- Repositories ---
  getIt.registerLazySingleton(
    () => ChannelsRepository(client: getIt<ChannelsClient>()),
  );
}

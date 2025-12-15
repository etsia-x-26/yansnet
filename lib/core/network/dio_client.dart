import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Configuration centralisée du client Dio pour l'application
class DioClient {
  /// Crée et configure une instance Dio pour les appels API
  static Dio createDio({String? baseUrl}) {
    final dio = Dio(
      BaseOptions(
        // CONFIGURATION IMPORTANTE - A Changer selon l' environnement:
        //
        // Android Emulator: http://10.0.2.2:8085
        // iOS Simulator:     http://localhost:8085
        // Appareil Physique: http://TON_IP_LOCAL:8085
        //  (trouve ton IP avec 'ipconfig' ou 'ifconfig')
        //
        baseUrl: baseUrl ?? ApiConfig.getBaseUrl(),

        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur de logs pour le debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          // Affiche les logs uniquement en mode debug
          // ignore: avoid_print
          print('[DIO] $object');
        },
      ),
    );

    // Intercepteur de cache (optionnel mais recommandé)
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      //hitCacheOnErrorExcept: [401, 403], // Ne pas utiliser le cache sur erreurs auth
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Intercepteur d'authentification (à implémenter plus tard)
    // dio.interceptors.add(AuthInterceptor());

    return dio;
  }
}

/// Configuration des URLs de l'API selon l'environnement
class ApiConfig {
  // URL de base pour le développement local
  static const String devBaseUrl = 'http://localhost:8085';

  // URL pour Android Emulator
  static const String androidEmulatorUrl = 'http://10.0.2.2:8085';

  // URL pour appareil physique (remplace XXX.XXX.XXX.XXX par ton IP)
  static const String physicalDeviceUrl = 'http://192.168.1.XXX:8085';

  // URL de production (à configurer plus tard)
  static const String prodBaseUrl = 'https://api.yansnet.com';

  /// Retourne l'URL de base appropriée selon l'environnement
  ///
  /// Pour changer l'environnement, modifie cette méthode ou utilise
  /// des variables d'environnement (flavor)
  static String getBaseUrl() {
    // CHANGE ICI selon ton environnement de test:

    // Pour Android Emulator:
     return androidEmulatorUrl;

    // Pour iOS Simulator ou Web:
    // return devBaseUrl;

    // Pour appareil physique:
    // return physicalDeviceUrl;

    // Pour production:
    // return prodBaseUrl;
  }

  /// Endpoints de l'API
  static const String groupsEndpoint = '/api/groups';
  static const String messagesEndpoint = '/api/messages';
  static const String usersEndpoint = '/api/users';
}

/// Intercepteur d'authentification (exemple pour plus tard)
///
/// Ajoute automatiquement le token JWT aux requêtes
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    // TODO: Récupérer le token depuis SharedPreferences ou un AuthCubit
    // final token = await getStoredToken();

    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Gérer le refresh token si 401

    if (err.response?.statusCode == 401) {
      // Token expiré, rediriger vers login
      // navigateToLogin();
    }

    handler.next(err);
  }
}
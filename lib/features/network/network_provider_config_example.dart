// Exemple de configuration du NetworkProvider
// Copiez ce code dans votre fichier main.dart ou dans votre fichier de configuration DI

import 'domain/usecases/get_network_stats_usecase.dart';
import 'domain/usecases/get_network_suggestions_usecase.dart';
import 'domain/usecases/send_connection_request_usecase.dart';
import 'data/repositories/network_repository_impl.dart';
import 'data/datasources/network_remote_data_source.dart';
import 'presentation/providers/network_provider.dart';
import '../../core/network/api_client.dart';

/// Configuration du NetworkProvider avec toutes les dépendances
///
/// Utilisez cette fonction dans votre main.dart pour initialiser le provider
NetworkProvider createNetworkProvider(ApiClient apiClient) {
  // 1. Créer la source de données distante
  final remoteDataSource = NetworkRemoteDataSourceImpl(apiClient);

  // 2. Créer le repository
  final repository = NetworkRepositoryImpl(remoteDataSource);

  // 3. Créer les use cases
  final getNetworkStatsUseCase = GetNetworkStatsUseCase(repository);
  final getNetworkSuggestionsUseCase = GetNetworkSuggestionsUseCase(repository);
  final sendConnectionRequestUseCase = SendConnectionRequestUseCase(repository);

  // 4. Créer et retourner le provider
  return NetworkProvider(
    getNetworkStatsUseCase: getNetworkStatsUseCase,
    getNetworkSuggestionsUseCase: getNetworkSuggestionsUseCase,
    sendConnectionRequestUseCase: sendConnectionRequestUseCase,
  );
}

/// Exemple d'utilisation dans main.dart
/// 
/// ```dart
/// void main() {
///   runApp(
///     MultiProvider(
///       providers: [
///         // ApiClient provider (doit être créé en premier)
///         Provider<ApiClient>(
///           create: (_) => ApiClient(baseUrl: 'https://yansnetapi.enlighteninnovation.com'),
///         ),
///         
///         // AuthProvider (doit être créé avant NetworkProvider)
///         ChangeNotifierProvider<AuthProvider>(
///           create: (context) => AuthProvider(...),
///         ),
///         
///         // NetworkProvider avec toutes les dépendances
///         ChangeNotifierProvider<NetworkProvider>(
///           create: (context) {
///             final apiClient = context.read<ApiClient>();
///             return createNetworkProvider(apiClient);
///           },
///         ),
///         
///         // ... autres providers
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```

/// Alternative : Configuration inline dans main.dart
/// 
/// ```dart
/// ChangeNotifierProvider<NetworkProvider>(
///   create: (context) {
///     final apiClient = context.read<ApiClient>();
///     final remoteDataSource = NetworkRemoteDataSourceImpl(apiClient);
///     final repository = NetworkRepositoryImpl(remoteDataSource);
///     
///     return NetworkProvider(
///       getNetworkStatsUseCase: GetNetworkStatsUseCase(repository),
///       getNetworkSuggestionsUseCase: GetNetworkSuggestionsUseCase(repository),
///       sendConnectionRequestUseCase: SendConnectionRequestUseCase(repository),
///     );
///   },
/// ),
/// ```

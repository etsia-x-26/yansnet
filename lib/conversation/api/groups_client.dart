import 'package:dio/dio.dart';
import 'package:yansnet/conversation/models/group.dart';

/// Client API pour gérer les groupes de conversation
class GroupsClient {
  GroupsClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Récupère la liste de tous les groupes depuis le backend
  ///
  /// Route: GET /api/groups
  ///
  /// Throws [Exception] en cas d'erreur réseau ou serveur
  Future<List<Group>> getGroups() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/api/groups',
      );

      if (response.data == null) {
        return [];
      }

      return (response.data! as List)
          .map((json) => Group.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gère les erreurs Dio et retourne des messages appropriés
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Délai de connexion dépassé. Vérifiez votre connexion internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Aucun groupe trouvé.');
        } else if (statusCode == 500) {
          return Exception('Erreur serveur. Veuillez réessayer plus tard.');
        } else if (statusCode == 401) {
          return Exception('Non autorisé. Veuillez vous reconnecter.');
        }
        return Exception(
          'Erreur ${error.response?.statusCode}: ${error.response?.statusMessage}',
        );

      case DioExceptionType.cancel:
        return Exception('Requête annulée.');

      case DioExceptionType.connectionError:
        return Exception(
          'Impossible de se connecter au serveur. '
              'Vérifiez que votre backend Docker est lancé sur le port 8085.',
        );

      case DioExceptionType.badCertificate:
        return Exception('Erreur de certificat SSL.');

      case DioExceptionType.unknown:
      default:
        return Exception(
          'Erreur inattendue: ${error.message ?? "Erreur inconnue"}',
        );
    }
  }
}
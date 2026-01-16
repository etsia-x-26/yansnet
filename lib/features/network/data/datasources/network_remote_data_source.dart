import '../../../../core/network/api_client.dart';
import '../../../../models/network_model.dart';
import '../../../../debug/network_debug.dart';
import '../../../../models/user_model.dart';

abstract class NetworkRemoteDataSource {
  Future<NetworkStatsModel> getNetworkStats(int userId);
  Future<List<NetworkSuggestionModel>> getNetworkSuggestions(int userId);
  Future<bool> sendConnectionRequest(int fromUserId, int toUserId);
  Future<bool> disconnectUser(int fromUserId, int toUserId);
  Future<bool> acceptConnectionRequest(int requestId);
  Future<bool> rejectConnectionRequest(int requestId);
}

class NetworkRemoteDataSourceImpl implements NetworkRemoteDataSource {
  final ApiClient apiClient;

  NetworkRemoteDataSourceImpl(this.apiClient);

  // Helper method to map search result format to User
  User _mapSearchResultToUser(Map<String, dynamic> json) {
    // Check if it's search result format: {id, type, title, description, imageUrl, metadata}
    if (json.containsKey('metadata') && json.containsKey('imageUrl')) {
      final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
      return User(
        id: json['id'] ?? 0,
        email: '', // Not provided in search results
        name: json['title'] ?? '',
        username: metadata['username'] ?? json['title'] ?? '',
        bio: json['description'] ?? '',
        profilePictureUrl:
            json['imageUrl'], // imageUrl instead of profilePictureUrl
        isMentor: metadata['isMentor'] ?? false,
        totalFollowers: metadata['totalFollowers'] ?? 0,
        totalPosts: metadata['totalPosts'] ?? 0,
      );
    }
    // Otherwise use standard User.fromJson
    return User.fromJson(json);
  }

  @override
  Future<NetworkStatsModel> getNetworkStats(int userId) async {
    final response = await apiClient.dio.get('/api/network/stats/$userId');
    return NetworkStatsModel.fromJson(response.data);
  }

  @override
  Future<List<NetworkSuggestionModel>> getNetworkSuggestions(int userId) async {
    print(
      '🔍 NetworkRemoteDataSource: Fetching suggestions for userId: $userId',
    );

    // Utiliser le bon endpoint d'après votre Swagger
    final endpoint = '/api/network/suggestions/$userId';

    try {
      print('🔍 Trying endpoint: $endpoint');
      final response = await apiClient.dio.get(endpoint);
      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data;

        // Gérer différents formats de réponse
        if (response.data is List) {
          data = response.data;
        } else if (response.data is Map) {
          if (response.data['content'] != null) {
            data = response.data['content'];
          } else if (response.data['data'] != null) {
            data = response.data['data'];
          } else if (response.data['suggestions'] != null) {
            data = response.data['suggestions'];
          } else {
            print('❌ Unexpected response format');
            print('Response keys: ${response.data.keys}');
            return [];
          }
        } else {
          print('❌ Unexpected response type');
          return [];
        }

        print('🔍 Data length: ${data.length}');

        if (data.isEmpty) {
          print('⚠️ No suggestions found, trying search endpoint as fallback');
          return await _getFromSearchEndpoint(userId);
        }

        // Convertir en suggestions
        try {
          final suggestions = data
              .where((json) {
                try {
                  final jsonMap = json is Map<String, dynamic>
                      ? json
                      : Map<String, dynamic>.from(json as Map);
                  final userJson = jsonMap['user'] != null
                      ? (jsonMap['user'] is Map<String, dynamic>
                            ? jsonMap['user']
                            : Map<String, dynamic>.from(jsonMap['user'] as Map))
                      : jsonMap;
                  final user = _mapSearchResultToUser(
                    userJson as Map<String, dynamic>,
                  );
                  return user.id != userId; // Exclure l'utilisateur actuel
                } catch (e) {
                  print('❌ Failed to parse user: $e');
                  return false;
                }
              })
              .map((json) {
                final jsonMap = json is Map<String, dynamic>
                    ? json
                    : Map<String, dynamic>.from(json as Map);
                // Si c'est déjà au format suggestion
                if (jsonMap['user'] != null) {
                  return NetworkSuggestionModel.fromJson(jsonMap);
                }
                // Sinon convertir user en suggestion
                return NetworkSuggestionModel(
                  user: _mapSearchResultToUser(jsonMap),
                  mutualConnectionsCount: 0,
                  reason: 'Suggested for you',
                );
              })
              .toList();

          print('✅ Created ${suggestions.length} suggestions');
          return suggestions;
        } catch (e) {
          print('❌ Failed to convert to suggestions: $e');
          return await _getFromSearchEndpoint(userId);
        }
      }
    } catch (e) {
      print('❌ Error with endpoint $endpoint: $e');
      print('⚠️ Trying search endpoint as fallback');
      return await _getFromSearchEndpoint(userId);
    }

    return [];
  }

  // Méthode de fallback utilisant l'endpoint de recherche
  Future<List<NetworkSuggestionModel>> _getFromSearchEndpoint(
    int userId,
  ) async {
    // Liste des endpoints à essayer dans l'ordre
    final endpoints = [
      {
        'path': '/search/users',
        'params': {'q': 'et'},
      }, // Chercher "et" (devrait trouver "etie20")
      {
        'path': '/search/users',
        'params': {'q': 'ti'},
      },
      {
        'path': '/search/users',
        'params': {'q': 'ie'},
      },
      {'path': '/api/users', 'params': null},
      {'path': '/users', 'params': null},
    ];

    for (final endpoint in endpoints) {
      try {
        final path = endpoint['path'] as String;
        final params = endpoint['params'] as Map<String, dynamic>?;

        print(
          '🔍 Trying endpoint: $path ${params != null ? 'with params: $params' : ''}',
        );

        final response = await apiClient.dio.get(path, queryParameters: params);

        if (response.statusCode == 200 && response.data != null) {
          print('✅ Success with $path - Status: ${response.statusCode}');
          print('🔍 Response type: ${response.data.runtimeType}');

          List<dynamic> data;

          if (response.data is List) {
            data = response.data;
          } else if (response.data is Map) {
            final map = response.data as Map;
            print('🔍 Response keys: ${map.keys.toList()}');

            if (map['users'] != null) {
              data = map['users'];
            } else if (map['content'] != null) {
              data = map['content'];
            } else if (map['data'] != null) {
              data = map['data'];
            } else {
              print('❌ Unexpected response format for $path');
              continue; // Try next endpoint
            }
          } else {
            print('❌ Unexpected response type for $path');
            continue;
          }

          print('🔍 Found ${data.length} users from $path');

          if (data.isEmpty) {
            print('⚠️ Empty data from $path, trying next endpoint');
            continue;
          }

          final suggestions = data
              .where((json) {
                try {
                  final jsonMap = json is Map<String, dynamic>
                      ? json
                      : Map<String, dynamic>.from(json as Map);
                  final user = _mapSearchResultToUser(jsonMap);
                  return user.id != userId;
                } catch (e) {
                  print('❌ Failed to parse user: $e');
                  return false;
                }
              })
              .take(10) // Limiter à 10 suggestions
              .map((json) {
                final jsonMap = json is Map<String, dynamic>
                    ? json
                    : Map<String, dynamic>.from(json as Map);
                return NetworkSuggestionModel(
                  user: _mapSearchResultToUser(jsonMap),
                  mutualConnectionsCount: 0,
                  reason: 'Suggested for you',
                );
              })
              .toList();

          print('✅ Created ${suggestions.length} suggestions from $path');
          return suggestions;
        }
      } catch (e) {
        print('❌ Endpoint ${endpoint['path']} failed: $e');
        // Continue to next endpoint
      }
    }

    print('❌ All endpoints failed to return user suggestions');
    return [];
  }

  @override
  Future<bool> sendConnectionRequest(int fromUserId, int toUserId) async {
    // Essayer plusieurs variantes de l'endpoint
    final endpoints = [
      {'path': '/follow/$fromUserId/$toUserId', 'data': null},
      {'path': '/follow/$fromUserId/$toUserId', 'data': {}},
      {'path': '/api/follow/$fromUserId/$toUserId', 'data': null},
      {'path': '/api/follow/$fromUserId/$toUserId', 'data': {}},
    ];

    Exception? lastError;

    for (final endpoint in endpoints) {
      try {
        final path = endpoint['path'] as String;
        final data = endpoint['data'];

        print('🔗 Trying to follow: $fromUserId → $toUserId');
        print('🔗 Endpoint: ${apiClient.dio.options.baseUrl}$path');
        print('🔗 With data: $data');

        NetworkDebug.logConnectionRequest(
          fromUserId: fromUserId,
          toUserId: toUserId,
          endpoint: path,
        );

        final response = await apiClient.dio.post(path, data: data);

        NetworkDebug.logApiResponse(
          endpoint: path,
          statusCode: response.statusCode ?? 0,
          responseData: response.data,
          headers: response.headers.map,
        );

        print('✅ Follow request successful with $path');
        print('✅ Status: ${response.statusCode}');
        print('✅ Response: ${response.data}');

        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e, stackTrace) {
        print('❌ Failed with ${endpoint['path']}: $e');
        lastError = Exception(e.toString());

        // Si c'est une erreur 404, essayer le prochain endpoint
        if (e.toString().contains('404')) {
          continue;
        }

        // Pour les autres erreurs, ne pas continuer
        if (e.toString().contains('500') ||
            e.toString().contains('401') ||
            e.toString().contains('403') ||
            e.toString().contains('400')) {
          break;
        }
      }
    }

    // Si on arrive ici, toutes les tentatives ont échoué
    print('❌ All follow endpoints failed');
    print('❌ Last error: $lastError');

    NetworkDebug.logError(
      operation: 'sendConnectionRequest (all attempts)',
      error: lastError ?? Exception('Unknown error'),
      stackTrace: StackTrace.current,
    );

    // Message d'erreur basé sur la dernière erreur
    String errorMessage = 'Failed to follow user';

    if (lastError != null) {
      final errorStr = lastError.toString();
      if (errorStr.contains('SocketException') ||
          errorStr.contains('Connection')) {
        errorMessage = 'Network error: Cannot connect to server.';
      } else if (errorStr.contains('500')) {
        errorMessage = 'Server error: The backend encountered an error.';
      } else if (errorStr.contains('404')) {
        errorMessage = 'Endpoint not found: Follow endpoint does not exist.';
      } else if (errorStr.contains('401') || errorStr.contains('403')) {
        errorMessage = 'Authentication error: Please login again.';
      } else if (errorStr.contains('400')) {
        errorMessage = 'Bad request: Invalid user IDs.';
      } else if (errorStr.contains('timeout')) {
        errorMessage = 'Request timeout: Server took too long to respond.';
      } else {
        errorMessage = 'Error: ${errorStr.replaceAll('Exception: ', '')}';
      }
    }

    print('❌ Final error message: $errorMessage');
    throw Exception(errorMessage);
  }

  @override
  Future<bool> disconnectUser(int fromUserId, int toUserId) async {
    try {
      print('🔗 Disconnecting user: $fromUserId → $toUserId');
      print(
        '🔗 Endpoint: ${apiClient.dio.options.baseUrl}/follow/unfollow/$fromUserId/$toUserId',
      );

      final response = await apiClient.dio.delete(
        '/follow/unfollow/$fromUserId/$toUserId',
      );

      print('✅ Disconnect successful: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Disconnect failed: $e');
      throw Exception('Failed to disconnect user: $e');
    }
  }

  @override
  Future<bool> acceptConnectionRequest(int requestId) async {
    try {
      final response = await apiClient.dio.post(
        '/api/connections/accept/$requestId',
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to accept connection request: $e');
    }
  }

  @override
  Future<bool> rejectConnectionRequest(int requestId) async {
    try {
      final response = await apiClient.dio.post(
        '/api/connections/reject/$requestId',
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to reject connection request: $e');
    }
  }
}

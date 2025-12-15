import 'package:dio/dio.dart';
import 'package:yansnet/publication/models/publication_response.dart';

class PublicationClient {
  PublicationClient(this._dio);
  final Dio _dio;

  Future<void> createPost(String content) async {
    try {
      print('📤 Creating post with content: $content');

      final response = await _dio.post(
        '/api/posts',
        data: {
          'content': content,
          'userId': 3, // TODO: Remplacer par l'ID de l'utilisateur connecté
          'medias': [], // Vide pour l'instant (pas d'images)
        },
      );

      print('✅ Post created successfully: ${response.statusCode}');
      print('📦 Response data: ${response.data}');
    } on DioException catch (e) {
      print('❌ DioException in createPost: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Response status: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      throw Exception('Failed to create post: ${_getErrorMessage(e)}');
    }
  }

  Future<PublicationResponse> fetchPosts({
    int page = 0,
    int size = 10,
  }) async {
    try {
      print('🔵 Fetching posts from: /api/posts?page=$page&size=$size');

      final response = await _dio.get(
        '/api/posts',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('✅ Response status: ${response.statusCode}');
      print('📦 Response data type: ${response.data.runtimeType}');

      // Afficher les premières lignes du JSON
      final jsonString = response.data.toString();
      print('📦 Response data (first 500 chars): ${jsonString.substring(0, jsonString.length > 500 ? 500 : jsonString.length)}');

      // Vérifier si la réponse est bien un Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: expected Map, got ${response.data.runtimeType}');
      }

      print('🔄 Attempting to parse JSON...');
      final result = PublicationResponse.fromJson(response.data as Map<String, dynamic>);
      print('✅ JSON parsed successfully! Posts count: ${result.content.length}');

      return result;
    } on DioException catch (e) {
      print('❌ DioException in fetchPosts: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Response status: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      print('❌ Request URL: ${e.requestOptions.uri}');

      throw Exception('Failed to fetch posts: ${_getErrorMessage(e)}');
    } catch (e, stackTrace) {
      print('❌ Unknown error in fetchPosts: $e');
      print('❌ StackTrace: $stackTrace');
      throw Exception('Failed to fetch posts: $e');
    }
  }

  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        return 'Server error ($statusCode): ${data?.toString() ?? "Unknown error"}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error - Check if backend is running';
      case DioExceptionType.unknown:
        return 'Unknown error: ${e.message}';
      default:
        return e.message ?? 'Unknown error';
    }
  }
}
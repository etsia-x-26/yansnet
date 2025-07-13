import 'package:dio/dio.dart';

import '../models/publication_response.dart';

class PublicationClient {

  PublicationClient(this._dio);
  final Dio _dio;
  final String _baseUrl = 'http://192.168.1.100:8081/api';

  Future<void> createPost(String content) async {
    try {
      await _dio.post(
        '$_baseUrl/posts',
        data: {
          'content': content,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to create post: ${e.message}');
    }
  }

  Future<PublicationResponse> fetchPosts({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/posts',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return PublicationResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch posts: ${e.message}');
    }
  }


}
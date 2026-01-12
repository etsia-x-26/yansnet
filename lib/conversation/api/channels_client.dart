// lib/conversation/api/channels_client.dart
import 'package:dio/dio.dart';
import '../models/channel.dart';
import '../models/channel_post.dart';

class ChannelsClient {
  final Dio _dio;

  // Le client attend maintenant une instance de Dio, il ne la crée plus lui-même.
  ChannelsClient(this._dio);

  // -------- CHANNELS (Groups in API) --------

  Future<List<Channel>> getChannels() async {
    try {
      final response = await _dio.get('/api/groups');
      return (response.data as List)
          .map((json) => Channel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Channel> getChannelById(int id) async {
    try {
      final response = await _dio.get('/api/channel/$id');
      return Channel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Channel> createChannel({
    required String name,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        '/api/channel',
        data: {
          'title': name,
          'description': description,
        },
      );
      return Channel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // -------- POSTS --------

  Future<List<ChannelPost>> getChannelPosts({
    int? channelId,
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String direction = 'desc',
  }) async {
    try {
      final response = await _dio.get(
        '/api/posts',
        queryParameters: {
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'direction': direction,
        },
      );

      final content = response.data['content'] as List;
      List<ChannelPost> posts = content
          .map((json) => ChannelPost.fromJson(json as Map<String, dynamic>))
          .toList();

      if (channelId != null) {
        posts = posts.where((post) => post.channel?.id == channelId).toList();
      }

      return posts;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChannelPost> createPost({
    required String content,
    required int userId,
    int? channelId,
    List<Map<String, dynamic>>? medias,
  }) async {
    try {
      final response = await _dio.post(
        '/api/posts',
        data: {
          'content': content,
          'userId': userId,
          if (channelId != null) 'groupId': channelId,
          if (medias != null) 'media': medias,
        },
      );
      return ChannelPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChannelPost> updatePost({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await _dio.patch(
        '/api/posts',
        data: {
          'id': postId,
          'content': content,
        },
      );
      return ChannelPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await _dio.delete('/api/posts/$postId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // -------- REACTIONS --------

  Future<void> reactToPost({
    required int postId,
    required int userId,
    required String emoji,
  }) async {
    try {
      await _dio.post(
        '/api/post-reactions/react',
        data: {
          'postId': postId,
          'userId': userId,
          'emoji': emoji,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // -------- FOLLOW/UNFOLLOW GROUP (Channel) --------

  Future<void> followChannel({
    required int channelId,
    required int followerId,
  }) async {
    try {
      await _dio.post(
        '/api/group-follow/follow/$channelId/$followerId',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> unfollowChannel({
    required int channelId,
    required int followerId,
  }) async {
    try {
      await _dio.delete(
        '/api/group-follow/unfollow/$channelId/$followerId',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // -------- ERROR HANDLING --------

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Erreur réseau: Problème de connexion ou de CORS. ${e.error}');
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Délai de connexion dépassé.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data is Map
            ? e.response?.data['message']?.toString() ?? 'Erreur serveur'
            : 'Erreur serveur inconnue.';

        switch (statusCode) {
          case 400:
            return Exception('Requête invalide: $message');
          case 401:
            return Exception('Non autorisé. Veuillez vous reconnecter.');
          case 403:
            return Exception('Accès refusé.');
          case 404:
            return Exception('Ressource non trouvée.');
          case 500:
            return Exception('Erreur serveur interne.');
          default:
            return Exception('Erreur $statusCode: $message');
        }

      case DioExceptionType.cancel:
        return Exception('Requête annulée.');

      default:
        return Exception('Erreur inconnue: ${e.message}');
    }
  }
}

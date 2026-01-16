import '../../../../core/network/api_client.dart';
import '../../domain/entities/post_entity.dart' as entity;
import '../../../../models/post_model.dart' as model;
import '../../domain/entities/comment_entity.dart';
import '../../../channels/domain/entities/channel_entity.dart' as channel_entity;
import '../../../auth/domain/auth_domain.dart' as auth_entity;

import '../../../../models/user_model.dart' as user_model; // This import was in the original and is still needed for _mapUser. The provided snippet was incomplete.
// The instruction was "Add import for comment_entity.dart" and then showed a *modified* import block.
// I will assume the user wants the imports to be as shown in the "Code Edit" snippet,
// but also retaining necessary imports that were implicitly removed by the snippet's brevity.
// Specifically, `user_model` is used later in the file, so it must be kept.
// The `comment_entity.dart` import is already present in the original file, but the instruction implies it should be added/rearranged.
// I will use the order from the "Code Edit" snippet and ensure all necessary imports are present.

abstract class PostRemoteDataSource {
  Future<List<entity.Post>> getPosts({int page = 0, int size = 10});
  Future<List<entity.Post>> getFollowingFeed({int page = 0, int size = 10});
  Future<List<entity.Post>> getPostsByUser(int userId, {int page = 0, int size = 10});
  Future<entity.Post> createPost(String content, {List<String>? mediaPaths});
  
  Future<List<Comment>> getComments(int postId, {int page = 0, int size = 10});
  Future<Comment> addComment(int postId, String content);
  Future<void> deleteComment(int commentId);
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
  Future<void> deletePost(int postId);
  Future<entity.Post> updatePost(int postId, String content);
}



class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<entity.Post>> getPosts({int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.dio.get('/api/posts', queryParameters: {
        'page': page,
        'size': size,
        'sortBy': 'createdAt',
        'direction': 'desc',
      });

      final data = response.data;
      if (data != null && data['content'] != null) {
        return (data['content'] as List).map((e) {
          final postModel = model.Post.fromJson(e);
          return _mapModelToEntity(postModel);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error posts: $e');
      return []; // Or rethrow
    }
  }

  @override
  Future<List<entity.Post>> getFollowingFeed({int page = 0, int size = 10}) async {
    try {
      final userId = await _getUserId();
      final response = await apiClient.dio.get('/api/posts/feed', queryParameters: {
        'user': userId,
        'page': page,
        'size': size,
      });

      final data = response.data;
      if (data != null && data['content'] != null) {
        return (data['content'] as List).map((e) {
          final postModel = model.Post.fromJson(e);
          return _mapModelToEntity(postModel);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error feed: $e');
      return [];
    }
  }

  @override
  Future<List<entity.Post>> getPostsByUser(int userId, {int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.dio.get('/api/posts/user/$userId', queryParameters: {
        'page': page,
        'size': size,
      });

      final data = response.data;
      if (data != null && data['content'] != null) {
        return (data['content'] as List).map((e) {
          final postModel = model.Post.fromJson(e);
          return _mapModelToEntity(postModel);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error user posts: $e');
      return []; 
    }
  }

  @override
  Future<entity.Post> createPost(String content, {List<String>? mediaPaths}) async {
    final userId = await _getUserId();
    
    // Transform mediaPaths (URLs) to MediaDto list format expected by API
    // API Expects: "medias": [{"url": "...", "type": "IMAGE"}]
    List<Map<String, dynamic>> mediaList = [];
    if (mediaPaths != null) {
      for (var path in mediaPaths) {
        mediaList.add({
          "url": path,
          "type": "IMAGE" // Defaulting to IMAGE, simplified
        });
      }
    }

    final response = await apiClient.dio.post('/api/posts', data: {
      'content': content,
      'userId': userId,
      'medias': mediaList
    });
    return _mapModelToEntity(model.Post.fromJson(response.data));
  }

  @override
  Future<void> deletePost(int postId) async {
    await apiClient.dio.delete('/api/posts/$postId');
  }

  @override
  Future<entity.Post> updatePost(int postId, String content) async {
    final userId = await _getUserId();
    final response = await apiClient.dio.patch('/api/posts', data: {
      'id': postId,
      'content': content,
      'user': {'id': userId},
    });
    return _mapModelToEntity(model.Post.fromJson(response.data));
  }

  @override
  Future<List<Comment>> getComments(int postId, {int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.dio.get('/api/comments', queryParameters: {
        'postId': postId,
        'page': page, // ...
        'size': size,
        'sortBy': 'createdAt',
        'direction': 'asc',
      });
      // ... same implementation ...
      final data = response.data;
       if (data != null && data['content'] != null) {
         return (data['content'] as List).map((e) {
            return Comment(
              id: e['id'] ?? 0, 
              content: e['content'] ?? '', 
              createdAt: e['createdAt'] != null ? DateTime.parse(e['createdAt']) : DateTime.now(),
              totalLikes: e['totalLikes'] ?? 0,
              user: e['user'] != null ? _mapUser(user_model.User.fromJson(e['user'])) : null,
            );
         }).toList();
       }
       return [];
    } catch(e) {
      print('Error comments: $e');
      return [];
    }
  }

  @override
  Future<Comment> addComment(int postId, String content) async {
     final userIdStr = await apiClient.storage.read(key: 'user_id');
     final userId = int.parse(userIdStr!);
     
     final response = await apiClient.dio.post('/api/comments', data: {
       'postId': postId,
       'userId': userId,
       'content': content,
     });
     
     final e = response.data;
     return Comment(
        id: e['id'] ?? 0, 
        content: e['content'] ?? '', 
        createdAt: e['createdAt'] != null ? DateTime.parse(e['createdAt']) : DateTime.now(),
        totalLikes: e['totalLikes'] ?? 0,
        user: e['user'] != null ? _mapUser(user_model.User.fromJson(e['user'])) : null,
     );
  }

  @override
  Future<void> deleteComment(int commentId) async {
    await apiClient.dio.delete('/api/comments', queryParameters: {'id': commentId});
  }

  @override
  Future<void> likePost(int postId) async {
    final userId = await _getUserId();
    await apiClient.dio.post('/api/interactions/posts/$postId/like', queryParameters: {'user': userId});
  }

  @override
  Future<void> unlikePost(int postId) async {
    final userId = await _getUserId();
    await apiClient.dio.delete('/api/interactions/posts/$postId/unlike', queryParameters: {'user': userId});
  }

  Future<int> _getUserId() async {
    final userIdStr = await apiClient.storage.read(key: 'user_id');
    if (userIdStr != null) {
      return int.parse(userIdStr);
    }
    return 0; // Default or throw
  }

  entity.Post _mapModelToEntity(model.Post model) {
    return entity.Post(
      id: model.id,
      content: model.content,
      createdAt: model.createdAt,
      totalLikes: model.totalLikes,
      totalComments: model.totalComments,
      user: model.user != null ? _mapUser(model.user!) : null,
      channel: model.channel != null ? _mapChannel(model.channel!) : null, 
      media: model.media.map((m) => entity.Media(id: m.id, url: m.url, type: m.type)).toList(),
      isLiked: model.isLiked,
    );
  }

  auth_entity.User _mapUser(user_model.User u) {
    return auth_entity.User(
      id: u.id,
      email: u.email,
      name: u.name,
      username: u.username,
      bio: u.bio,
      profilePictureUrl: u.profilePictureUrl,
      isMentor: u.isMentor,
    );
  }

  channel_entity.Channel _mapChannel(model.Channel c) {
    // Note: channel definition might differ slightly or need alias
    // In PostEntity I defined Channel class too.
    return channel_entity.Channel(
      id: c.id,
      title: c.title,
      description: c.description,
      totalFollowers: c.totalFollowers,
    );
  }
}

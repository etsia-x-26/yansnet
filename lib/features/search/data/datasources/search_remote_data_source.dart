import '../../../../core/network/api_client.dart';
import '../../../../models/user_model.dart';
import '../../../../models/post_model.dart';
import '../../../auth/domain/auth_domain.dart' as auth;
import '../../../posts/domain/entities/post_entity.dart' as post_entity;
import '../../../channels/domain/entities/channel_entity.dart'; // For mapping in post if needed

abstract class SearchRemoteDataSource {
  Future<List<auth.User>> searchUsers(String query);
  Future<List<post_entity.Post>> searchPosts(String query);
  // Add other types like Jobs, Events if needed
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<auth.User>> searchUsers(String query) async {
    try {
      final response = await apiClient.dio.get('/api/search/users', queryParameters: {'q': query});
      // Assuming response is List or Page
      final data = response.data;
      if (data is List) {
        return data.map((e) => _mapUser(User.fromJson(e))).toList();
      } else if (data['content'] != null) {
        return (data['content'] as List).map((e) => _mapUser(User.fromJson(e))).toList();
      }
      return [];
    } catch (e) {
      print('Search Users Error: $e');
      return [];
    }
  }

  @override
  Future<List<post_entity.Post>> searchPosts(String query) async {
    try {
      final response = await apiClient.dio.get('/api/search/posts', queryParameters: {'q': query});
      final data = response.data;
      if (data is List) {
        return data.map((e) => _mapPost(Post.fromJson(e))).toList();
      } else if (data['content'] != null) {
         return (data['content'] as List).map((e) => _mapPost(Post.fromJson(e))).toList();
      }
      return [];
    } catch (e) {
      print('Search Posts Error: $e');
      return [];
    }
  }

  auth.User _mapUser(User u) {
    return auth.User(
      id: u.id,
      email: u.email,
      name: u.name,
      username: u.username,
      bio: u.bio,
      profilePictureUrl: u.profilePictureUrl, // Fix: Ensure User model has this field or map correctly
      isMentor: u.isMentor ?? false,
    );
  }

  post_entity.Post _mapPost(Post p) {
     return post_entity.Post(
      id: p.id,
      content: p.content,
      createdAt: p.createdAt,
      totalLikes: p.totalLikes,
      totalComments: p.totalComments,
      user: p.user != null ? _mapUser(p.user!) : null,
      channel: null, // Simplified for search
      media: p.media.map((m) => post_entity.Media(id: m.id, url: m.url, type: m.type)).toList(),
    );
  }
}

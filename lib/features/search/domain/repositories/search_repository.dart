import '../../../auth/domain/auth_domain.dart';
import '../../../posts/domain/entities/post_entity.dart';

abstract class SearchRepository {
  Future<List<User>> searchUsers(String query);
  Future<List<Post>> searchPosts(String query);
}

import '../entities/post_entity.dart';
import '../entities/comment_entity.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({int page = 0, int size = 10});
  Future<List<Post>> getFollowingFeed({int page = 0, int size = 10});
  Future<List<Post>> getPostsByUser(int userId, {int page = 0, int size = 10});
  Future<Post> createPost(String content, {List<String>? mediaPaths});

  // Interactions
  Future<List<Comment>> getComments(int postId, {int page = 0, int size = 10});
  Future<Comment> addComment(int postId, String content);
  Future<void> deleteComment(int commentId);
  
  // Likes
  Future<void> likePost(int postId);
  Future<void> unlikePost(int postId);
  Future<void> deletePost(int postId);
  Future<Post> updatePost(int postId, String content);
}

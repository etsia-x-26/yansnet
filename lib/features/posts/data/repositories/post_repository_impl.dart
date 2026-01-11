import '../../domain/repositories/post_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../../data/datasources/post_remote_data_source.dart';

import '../../domain/entities/comment_entity.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts({int page = 0, int size = 10}) {
    return remoteDataSource.getPosts(page: page, size: size);
  }

  @override
  Future<Post> createPost(String content, {List<String>? mediaPaths}) {
    return remoteDataSource.createPost(content, mediaPaths: mediaPaths);
  }

  @override
  Future<List<Comment>> getComments(int postId, {int page = 0, int size = 10}) {
    return remoteDataSource.getComments(postId, page: page, size: size);
  }

  @override
  Future<Comment> addComment(int postId, String content) {
    return remoteDataSource.addComment(postId, content);
  }

  @override
  Future<void> deleteComment(int commentId) {
    return remoteDataSource.deleteComment(commentId);
  }

  @override
  Future<void> likePost(int postId) {
    return remoteDataSource.likePost(postId);
  }

  @override
  Future<void> unlikePost(int postId) async {
    await remoteDataSource.unlikePost(postId);
  }

  @override
  Future<void> deletePost(int postId) async {
    await remoteDataSource.deletePost(postId);
  }
}

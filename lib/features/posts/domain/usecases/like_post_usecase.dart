import '../repositories/post_repository.dart';

class LikePostUseCase {
  final PostRepository repository;

  LikePostUseCase(this.repository);

  Future<void> call(int postId) {
    return repository.likePost(postId);
  }
}

import '../repositories/post_repository.dart';

class UnlikePostUseCase {
  final PostRepository repository;

  UnlikePostUseCase(this.repository);

  Future<void> call(int postId) {
    return repository.unlikePost(postId);
  }
}

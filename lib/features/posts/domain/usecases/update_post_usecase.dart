import '../repositories/post_repository.dart';
import '../entities/post_entity.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Post> call(int postId, String content) {
    return repository.updatePost(postId, content);
  }
}

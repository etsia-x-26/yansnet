import '../repositories/post_repository.dart';
import '../entities/post_entity.dart';

class GetUserPostsUseCase {
  final PostRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<List<Post>> call(int userId) {
    return repository.getPostsByUser(userId);
  }
}

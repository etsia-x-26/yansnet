import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call({int page = 0, int size = 10}) {
    return repository.getPosts(page: page, size: size);
  }
}

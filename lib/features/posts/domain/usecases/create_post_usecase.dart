import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<Post> call(String content, {List<String>? mediaPaths}) {
    return repository.createPost(content, mediaPaths: mediaPaths);
  }
}

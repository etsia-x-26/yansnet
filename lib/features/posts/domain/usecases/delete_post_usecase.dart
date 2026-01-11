import '../repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repository;

  DeletePostUseCase(this.repository);

  Future<void> call(int postId) async {
    return await repository.deletePost(postId);
  }
}

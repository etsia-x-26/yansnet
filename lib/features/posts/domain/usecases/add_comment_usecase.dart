import '../entities/comment_entity.dart';
import '../repositories/post_repository.dart';

class AddCommentUseCase {
  final PostRepository repository;

  AddCommentUseCase(this.repository);

  Future<Comment> call(int postId, String content) {
    return repository.addComment(postId, content);
  }
}

import '../entities/comment_entity.dart';
import '../repositories/post_repository.dart';

class GetCommentsUseCase {
  final PostRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call(int postId, {int page = 0}) {
    return repository.getComments(postId, page: page);
  }
}

import '../repositories/post_repository.dart';
import '../entities/post_entity.dart';

class GetFollowingFeedUseCase {
  final PostRepository repository;

  GetFollowingFeedUseCase(this.repository);

  Future<List<Post>> call({int page = 0, int size = 10}) async {
    return await repository.getFollowingFeed(page: page, size: size);
  }
}

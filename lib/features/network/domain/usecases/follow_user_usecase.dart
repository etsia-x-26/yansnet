import '../repositories/network_repository.dart';

class FollowUserUseCase {
  final NetworkRepository repository;

  FollowUserUseCase(this.repository);

  Future<bool> call(int followerId, int followedId) {
    return repository.followUser(followerId, followedId);
  }
}

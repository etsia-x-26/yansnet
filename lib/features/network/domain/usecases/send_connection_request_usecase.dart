import '../repositories/network_repository.dart';

class SendConnectionRequestUseCase {
  final NetworkRepository repository;

  SendConnectionRequestUseCase(this.repository);

  Future<bool> call(int fromUserId, int toUserId) {
    return repository.sendConnectionRequest(fromUserId, toUserId);
  }
}

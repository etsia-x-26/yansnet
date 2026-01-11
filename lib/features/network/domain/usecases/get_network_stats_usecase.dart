import '../repositories/network_repository.dart';
import '../entities/network_entity.dart';

class GetNetworkStatsUseCase {
  final NetworkRepository repository;

  GetNetworkStatsUseCase(this.repository);

  Future<NetworkStats> call(int userId) {
    return repository.getNetworkStats(userId);
  }
}

import '../repositories/network_repository.dart';
import '../entities/network_entity.dart';

class GetNetworkSuggestionsUseCase {
  final NetworkRepository repository;

  GetNetworkSuggestionsUseCase(this.repository);

  Future<List<NetworkSuggestion>> call(int userId) {
    return repository.getNetworkSuggestions(userId);
  }
}

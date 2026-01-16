import '../entities/network_entity.dart';
abstract class NetworkRepository {
  Future<NetworkStats> getNetworkStats(int userId);
  Future<List<NetworkSuggestion>> getNetworkSuggestions(int userId);
  Future<bool> followUser(int followerId, int followedId);
}

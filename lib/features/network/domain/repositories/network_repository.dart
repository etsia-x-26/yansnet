import '../entities/network_entity.dart';

abstract class NetworkRepository {
  Future<NetworkStats> getNetworkStats(int userId);
  Future<List<NetworkSuggestion>> getNetworkSuggestions(int userId);
  Future<bool> sendConnectionRequest(int fromUserId, int toUserId);
  Future<bool> disconnectUser(int fromUserId, int toUserId);
  Future<bool> acceptConnectionRequest(int requestId);
  Future<bool> rejectConnectionRequest(int requestId);
}

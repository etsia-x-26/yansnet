import '../../../../core/network/api_client.dart';
import '../../../../models/network_model.dart';

abstract class NetworkRemoteDataSource {
  Future<NetworkStatsModel> getNetworkStats(int userId);
  Future<List<NetworkSuggestionModel>> getNetworkSuggestions(int userId);
  Future<bool> followUser(int followerId, int followedId);
}

class NetworkRemoteDataSourceImpl implements NetworkRemoteDataSource {
  final ApiClient apiClient;

  NetworkRemoteDataSourceImpl(this.apiClient);

  @override
  Future<NetworkStatsModel> getNetworkStats(int userId) async {
    final response = await apiClient.dio.get('/api/network/stats/$userId');
    return NetworkStatsModel.fromJson(response.data);
  }

  @override
  Future<List<NetworkSuggestionModel>> getNetworkSuggestions(int userId) async {
    final response = await apiClient.dio.get('/api/network/suggestions/$userId');
    final List<dynamic> data = response.data;
    return data.map((json) => NetworkSuggestionModel.fromJson(json)).toList();
  }

  @override
  Future<bool> followUser(int followerId, int followedId) async {
    try {
      await apiClient.dio.post('/follow/$followerId/$followedId');
      return true;
    } catch (e) {
      return false; 
    }
  }
}

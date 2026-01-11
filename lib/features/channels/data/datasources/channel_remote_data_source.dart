import '../../../../core/network/api_client.dart';
import '../../domain/entities/channel_entity.dart';
import '../models/channel_dto.dart';

abstract class ChannelRemoteDataSource {
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(String title, String description);
}

class ChannelRemoteDataSourceImpl implements ChannelRemoteDataSource {
  final ApiClient apiClient;

  ChannelRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Channel>> getChannels() async {
    final response = await apiClient.dio.get('/api/channels');
    final List data = response.data;
    return data.map((e) => ChannelDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<Channel> createChannel(String title, String description) async {
    final response = await apiClient.dio.post('/api/channels', data: {
      'title': title,
      'description': description,
    });
    return ChannelDto.fromJson(response.data).toEntity();
  }
}

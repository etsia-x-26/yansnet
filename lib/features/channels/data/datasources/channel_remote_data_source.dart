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
    final response = await apiClient.dio.post('/channel', data: {
      'name': title,
      'description': description,
    });
    // The API might return an object compatible with ChannelDto, need to verify or assume
    // Based on schema `ChannelDto`, it fits `Channel` entity.
    // The API response schema is just "object", assuming it returns the created channel.
    return ChannelDto.fromJson(response.data).toEntity();
  }
}

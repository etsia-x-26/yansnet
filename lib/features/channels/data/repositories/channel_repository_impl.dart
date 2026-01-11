import '../../domain/entities/channel_entity.dart';
import '../../domain/repositories/channel_repository.dart';
import '../datasources/channel_remote_data_source.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteDataSource remoteDataSource;

  ChannelRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Channel>> getChannels() {
    return remoteDataSource.getChannels();
  }

  @override
  Future<Channel> createChannel(String title, String description) {
    return remoteDataSource.createChannel(title, description);
  }
}

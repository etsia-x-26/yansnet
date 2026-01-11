import '../entities/channel_entity.dart';
import '../repositories/channel_repository.dart';

class GetChannelsUseCase {
  final ChannelRepository repository;

  GetChannelsUseCase(this.repository);

  Future<List<Channel>> call() {
    return repository.getChannels();
  }
}

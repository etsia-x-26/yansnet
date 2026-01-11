import '../entities/channel_entity.dart';
import '../repositories/channel_repository.dart';

class CreateChannelUseCase {
  final ChannelRepository repository;

  CreateChannelUseCase(this.repository);

  Future<Channel> call(String title, String description) {
    return repository.createChannel(title, description);
  }
}

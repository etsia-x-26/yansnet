import '../entities/channel_entity.dart';

abstract class ChannelRepository {
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(String title, String description);
}

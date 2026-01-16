import '../entities/channel_entity.dart';

abstract class ChannelRepository {
  Future<List<Channel>> getChannels();
  Future<Channel> createChannel(String title, String description);
  Future<Channel> getChannel(int channelId);
  Future<void> followChannel(int channelId, int followerId);
  Future<void> unfollowChannel(int channelId, int followerId);
}

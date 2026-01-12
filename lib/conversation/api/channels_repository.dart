import '../models/channel.dart';
import '../models/channel_post.dart';
import 'channels_client.dart';

class ChannelsRepository {
  final ChannelsClient _client;

  // Simple in-memory cache
  List<Channel>? _cachedChannels;
  DateTime? _lastFetchTime;

  ChannelsRepository({required ChannelsClient client}) : _client = client;

  bool get _isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 5);
  }

  // -------- CHANNELS --------

  Future<List<Channel>> getChannels({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid && _cachedChannels != null) {
      return _cachedChannels!;
    }
    final channels = await _client.getChannels();
    _cachedChannels = channels;
    _lastFetchTime = DateTime.now();
    return channels;
  }

  Future<Channel> getChannelById(int channelId) {
    return _client.getChannelById(channelId);
  }

  Future<Channel> createChannel({
    required String name,
    required String description,
  }) async {
    final channel = await _client.createChannel(
      name: name,
      description: description,
    );
    clearCache(); // Invalidate cache after creation
    return channel;
  }

  Future<void> subscribeToChannel({
    required int channelId,
    required int followerId,
  }) {
    clearCache();
    return _client.followChannel(
      channelId: channelId,
      followerId: followerId,
    );
  }

  Future<void> unsubscribeFromChannel({
    required int channelId,
    required int followerId,
  }) {
    clearCache();
    return _client.unfollowChannel(
      channelId: channelId,
      followerId: followerId,
    );
  }

  // -------- POSTS --------

  Future<List<ChannelPost>> getChannelPosts(
    int channelId, {
    int page = 0,
    int size = 20,
  }) {
    return _client.getChannelPosts(
      channelId: channelId,
      page: page,
      size: size,
    );
  }

  Future<ChannelPost> createPost({
    required String content,
    required int userId,
    required int channelId,
  }) {
    return _client.createPost(
      content: content,
      userId: userId,
      channelId: channelId,
    );
  }

  Future<ChannelPost> updatePost({
    required int postId,
    required String content,
  }) {
    return _client.updatePost(
      postId: postId,
      content: content,
    );
  }

  Future<void> deletePost(int postId) {
    return _client.deletePost(postId);
  }

  Future<void> reactToPost({
    required int postId,
    required int userId,
    required String emoji,
  }) {
    return _client.reactToPost(
      postId: postId,
      userId: userId,
      emoji: emoji,
    );
  }

  // -------- CACHE --------

  void clearCache() {
    _cachedChannels = null;
    _lastFetchTime = null;
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/channel_entity.dart';
import '../../domain/usecases/get_channels_usecase.dart';
import '../../domain/usecases/create_channel_usecase.dart';
import '../../domain/repositories/channel_repository.dart';

class ChannelsProvider extends ChangeNotifier {
  final GetChannelsUseCase getChannelsUseCase;
  final CreateChannelUseCase createChannelUseCase;
  final ChannelRepository channelRepository;

  List<Channel> _channels = [];
  Channel? _currentChannel;
  bool _isLoading = false;
  String? _error;

  ChannelsProvider({
    required this.getChannelsUseCase,
    required this.createChannelUseCase,
    required this.channelRepository,
  });

  List<Channel> get channels => _channels;
  Channel? get currentChannel => _currentChannel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChannels() async {
    print('📥 ChannelsProvider: Loading channels...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _channels = await getChannelsUseCase();
      print('✅ ChannelsProvider: Loaded ${_channels.length} channels');
    } catch (e) {
      print('❌ ChannelsProvider: Error loading channels: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createChannel(String title, String description) async {
    print('🆕 ChannelsProvider: Creating channel...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newChannel = await createChannelUseCase(title, description);
      _channels.insert(0, newChannel);
      print('✅ ChannelsProvider: Channel created');
      return true;
    } catch (e) {
      print('❌ ChannelsProvider: Error creating channel: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChannel(int channelId) async {
    print('📥 ChannelsProvider: Loading channel $channelId...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentChannel = await channelRepository.getChannel(channelId);
      print('✅ ChannelsProvider: Channel loaded');
    } catch (e) {
      print('❌ ChannelsProvider: Error loading channel: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> followChannel(int channelId, int followerId) async {
    print('➕ ChannelsProvider: Following channel $channelId...');
    try {
      await channelRepository.followChannel(channelId, followerId);

      // Update local state
      if (_currentChannel?.id == channelId) {
        _currentChannel = Channel(
          id: _currentChannel!.id,
          title: _currentChannel!.title,
          description: _currentChannel!.description,
          totalFollowers: _currentChannel!.totalFollowers + 1,
          isFollowing: true,
        );
      }

      print('✅ ChannelsProvider: Channel followed');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ ChannelsProvider: Error following channel: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unfollowChannel(int channelId, int followerId) async {
    print('➖ ChannelsProvider: Unfollowing channel $channelId...');
    try {
      await channelRepository.unfollowChannel(channelId, followerId);

      // Update local state
      if (_currentChannel?.id == channelId) {
        _currentChannel = Channel(
          id: _currentChannel!.id,
          title: _currentChannel!.title,
          description: _currentChannel!.description,
          totalFollowers: _currentChannel!.totalFollowers - 1,
          isFollowing: false,
        );
      }

      print('✅ ChannelsProvider: Channel unfollowed');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ ChannelsProvider: Error unfollowing channel: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/channels_repository.dart';
import '../models/channel.dart';
import '../models/channel_filter.dart';
import 'channels_state.dart';

class ChannelsCubit extends Cubit<ChannelsState> {
  final ChannelsRepository _repository;
  int? _currentUserId;

  ChannelsCubit({
    required ChannelsRepository repository,
    int? currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId,
        super(ChannelsInitial());

  void setUserId(int userId) {
    _currentUserId = userId;
  }

  Future<void> loadChannels({
    ChannelFilter filter = ChannelFilter.all,
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh && state is ChannelsLoaded) {
        final currentState = state as ChannelsLoaded;
        emit(currentState.copyWith(isRefreshing: true));
      } else {
        emit(ChannelsLoading());
      }

      final channels = await _repository.getChannels(forceRefresh: forceRefresh);

      final filteredChannels = _applyFilter(channels, filter);

      emit(ChannelsLoaded(
        channels: filteredChannels,
        currentFilter: filter,
        isRefreshing: false,
      ));
    } catch (e) {
      if (state is ChannelsLoaded) {
        final currentState = state as ChannelsLoaded;
        emit(ChannelsError(
          message: e.toString(),
          cachedChannels: currentState.channels,
        ));
      } else {
        emit(ChannelsError(message: e.toString()));
      }
    }
  }

  Future<void> refreshChannels() async {
    if (state is ChannelsLoaded) {
      final currentState = state as ChannelsLoaded;
      await loadChannels(
        filter: currentState.currentFilter,
        forceRefresh: true,
      );
    } else {
      await loadChannels(forceRefresh: true);
    }
  }

  Future<void> filterChannels(ChannelFilter filter) async {
    await loadChannels(filter: filter);
  }

  void searchChannels(String query) {
    if (state is! ChannelsLoaded) return;

    final currentState = state as ChannelsLoaded;

    if (query.isEmpty) {
      loadChannels(filter: currentState.currentFilter);
      return;
    }

    final filtered = currentState.channels.where((channel) {
      final name = channel.name?.toLowerCase() ?? '';
      final description = channel.description?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return name.contains(searchLower) || description.contains(searchLower);
    }).toList();

    emit(currentState.copyWith(channels: filtered));
  }

  Future<void> createChannel({
    required String name,
    required String description,
  }) async {
    try {
      await _repository.createChannel(
        name: name,
        description: description,
      );
      await refreshChannels();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleSubscription(Channel channel) async {
    if (state is! ChannelsLoaded || _currentUserId == null) return;

    final currentState = state as ChannelsLoaded;

    // Optimistic UI update
    final updatedChannel = channel.copyWith(
      isSubscribed: !channel.isSubscribed,
      subscriberCount: channel.isSubscribed
          ? channel.subscriberCount - 1
          : channel.subscriberCount + 1,
    );
    final updatedChannels = currentState.channels.map((c) {
      return c.id == channel.id ? updatedChannel : c;
    }).toList();

    emit(currentState.copyWith(channels: updatedChannels));

    try {
      if (channel.isSubscribed) {
        await _repository.unsubscribeFromChannel(
          channelId: channel.id,
          followerId: _currentUserId!,
        );
      } else {
        await _repository.subscribeToChannel(
          channelId: channel.id,
          followerId: _currentUserId!,
        );
      }
    } catch (e) {
      // Rollback on error
      emit(currentState);
    }
  }

  void clearCache() {
    _repository.clearCache();
  }

  List<Channel> _applyFilter(List<Channel> channels, ChannelFilter filter) {
    switch (filter) {
      case ChannelFilter.all:
        return channels;

      case ChannelFilter.subscribed:
        if (_currentUserId == null) {
          return [];
        }
        return channels.where((c) => c.isSubscribed).toList();

      case ChannelFilter.popular:
        final sorted = List<Channel>.from(channels);
        sorted.sort((a, b) => b.subscriberCount.compareTo(a.subscriberCount));
        return sorted;

      case ChannelFilter.recent:
        final sorted = List<Channel>.from(channels);
        sorted.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        return sorted;
    }
  }
}

import 'package:equatable/equatable.dart';
import '../models/channel.dart';
import '../models/channel_filter.dart';
import '../models/channel_post.dart';

// --- Base States ---
abstract class ChannelsState extends Equatable {
  const ChannelsState();
  @override
  List<Object?> get props => [];
}

abstract class ChannelDetailState extends Equatable {
  const ChannelDetailState();
  @override
  List<Object?> get props => [];
}

abstract class ChannelPostsState extends Equatable {
  const ChannelPostsState();
  @override
  List<Object?> get props => [];
}

// --- Channels List States ---
class ChannelsInitial extends ChannelsState {}

class ChannelsLoading extends ChannelsState {}

class ChannelsLoaded extends ChannelsState {
  final List<Channel> channels;
  final ChannelFilter currentFilter;
  final bool isRefreshing;

  const ChannelsLoaded({
    required this.channels,
    required this.currentFilter,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [channels, currentFilter, isRefreshing];

  ChannelsLoaded copyWith({
    List<Channel>? channels,
    ChannelFilter? currentFilter,
    bool? isRefreshing,
  }) {
    return ChannelsLoaded(
      channels: channels ?? this.channels,
      currentFilter: currentFilter ?? this.currentFilter,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ChannelsError extends ChannelsState {
  final String message;
  final List<Channel>? cachedChannels;

  const ChannelsError({required this.message, this.cachedChannels});

  @override
  List<Object?> get props => [message, cachedChannels];
}


// --- Channel Detail States ---

class ChannelDetailInitial extends ChannelDetailState {}

class ChannelDetailLoading extends ChannelDetailState {}

class ChannelDetailLoaded extends ChannelDetailState {
  final Channel channel;
  final bool isSubscribed;
  final bool isFollowLoading;

  const ChannelDetailLoaded({
    required this.channel,
    this.isSubscribed = false,
    this.isFollowLoading = false,
  });

  @override
  List<Object?> get props => [channel, isSubscribed, isFollowLoading];

  ChannelDetailLoaded copyWith({
    Channel? channel,
    bool? isSubscribed,
    bool? isFollowLoading,
  }) {
    return ChannelDetailLoaded(
      channel: channel ?? this.channel,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
    );
  }
}

class ChannelDetailError extends ChannelDetailState {
  final String message;
  const ChannelDetailError(this.message);
  @override
  List<Object> get props => [message];
}

// --- Channel Posts States ---

class ChannelPostsInitial extends ChannelPostsState {}

class ChannelPostsLoading extends ChannelPostsState {
  final bool isLoadingMore;
  const ChannelPostsLoading({this.isLoadingMore = false});
  @override
  List<Object> get props => [isLoadingMore];
}

class ChannelPostsLoaded extends ChannelPostsState {
  final List<ChannelPost> posts;
  final bool hasMore;
  final bool isLoadingMore;

  const ChannelPostsLoaded({
    required this.posts,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [posts, hasMore, isLoadingMore];

  ChannelPostsLoaded copyWith({
    List<ChannelPost>? posts,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ChannelPostsLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ChannelPostsError extends ChannelPostsState {
  final String message;
  const ChannelPostsError(this.message);
  @override
  List<Object> get props => [message];
}

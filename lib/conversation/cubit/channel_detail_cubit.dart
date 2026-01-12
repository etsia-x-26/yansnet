// lib/conversation/cubit/channel_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/channels_repository.dart';
import 'channels_state.dart';

class ChannelDetailCubit extends Cubit<ChannelDetailState> {
  final ChannelsRepository repository;
  final int channelId;
  final int currentUserId;

  ChannelDetailCubit({
    required this.repository,
    required this.channelId,
    required this.currentUserId,
  }) : super(ChannelDetailInitial());

  Future<void> loadChannelDetail() async {
    try {
      emit(ChannelDetailLoading());

      final channel = await repository.getChannelById(channelId);

      emit(ChannelDetailLoaded(
        channel: channel,
        isSubscribed: channel.isSubscribed,
      ));
    } catch (e) {
      emit(ChannelDetailError(e.toString()));
    }
  }

  Future<void> toggleSubscription() async {
    if (state is! ChannelDetailLoaded) return;

    final currentState = state as ChannelDetailLoaded;

    try {
      // Optimistic update
      emit(currentState.copyWith(isFollowLoading: true));

      if (currentState.isSubscribed) {
        await repository.unsubscribeFromChannel(
          channelId: channelId,
          followerId: currentUserId,
        );
      } else {
        await repository.subscribeToChannel(
          channelId: channelId,
          followerId: currentUserId,
        );
      }

      // Recharger pour avoir les vraies données
      final updatedChannel = await repository.getChannelById(channelId);

      emit(ChannelDetailLoaded(
        channel: updatedChannel,
        isSubscribed: !currentState.isSubscribed,
        isFollowLoading: false,
      ));
    } catch (e) {
      // Rollback en cas d'erreur
      emit(currentState.copyWith(isFollowLoading: false));
      emit(ChannelDetailError(e.toString()));
    }
  }

  Future<void> refreshChannel() async {
    await loadChannelDetail();
  }
}

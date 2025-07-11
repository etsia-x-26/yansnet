part of 'channel_cubit.dart';

@freezed
class ChannelState with _$ChannelState {
  const factory ChannelState.initial() = _Initial;
  const factory ChannelState.loading() = _Loading;
  const factory ChannelState.followed() = _Followed;
  const factory ChannelState.success({required List<Channel> channels}) = _Success;
  const factory ChannelState.error({required String message}) = _Error;
}

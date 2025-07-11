part of 'group_conversation_cubit.dart';

@freezed
class GroupConversationState with _$GroupConversationState {
  const factory GroupConversationState.initial() = _Initial;
  const factory GroupConversationState.loading() = _Loading;
  const factory GroupConversationState.success({
    required List<GroupConversation> message,
  }) = _Success;
  const factory GroupConversationState.error({required String message}) =
      _Error;
}

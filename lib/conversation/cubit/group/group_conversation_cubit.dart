import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yansnet/conversation/models/group_conversation.dart';

part 'group_conversation_state.dart';
part 'group_conversation_cubit.freezed.dart';

class GroupConversationCubit extends Cubit<GroupConversationState> {
  GroupConversationCubit() : super(const GroupConversationState.initial());
}

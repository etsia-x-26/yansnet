import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class CreateGroupConversationUseCase {
  final ChatRepository repository;

  CreateGroupConversationUseCase(this.repository);

  Future<Conversation> call(List<int> participantIds, String name) {
    return repository.createGroupConversation(participantIds, name);
  }
}

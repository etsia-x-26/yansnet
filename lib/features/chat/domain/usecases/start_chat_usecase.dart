import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class StartChatUseCase {
  final ChatRepository repository;

  StartChatUseCase(this.repository);

  Future<Conversation> call(int otherUserId) {
    return repository.createConversation(otherUserId);
  }
}

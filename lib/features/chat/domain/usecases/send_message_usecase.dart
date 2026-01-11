import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Message> call(int conversationId, String content) {
    return repository.sendMessage(conversationId, content);
  }
}

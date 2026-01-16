import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Message> call(int conversationId, String content, int userId, {String? type, String? url}) async {
    return await repository.sendMessage(conversationId, content, userId, type: type, url: url);
  }
}

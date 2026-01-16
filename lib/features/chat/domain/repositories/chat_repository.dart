import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessages(int conversationId);
  Future<Message> sendMessage(int conversationId, String content, int userId, {String? type, String? url});
  Future<Conversation> createConversation(int otherUserId); // Start chat with user
  Future<Conversation> createGroupConversation(List<int> participantIds, String name);
}

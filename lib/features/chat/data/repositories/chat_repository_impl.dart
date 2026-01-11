import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Conversation>> getConversations() {
    return remoteDataSource.getConversations();
  }

  @override
  Future<List<Message>> getMessages(int conversationId) {
    return remoteDataSource.getMessages(conversationId);
  }

  @override
  Future<Message> sendMessage(int conversationId, String content) {
    return remoteDataSource.sendMessage(conversationId, content);
  }

  @override
  Future<Conversation> createConversation(int otherUserId) {
    return remoteDataSource.createConversation(otherUserId);
  }
}

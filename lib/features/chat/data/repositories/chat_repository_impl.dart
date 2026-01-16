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
  Future<Message> sendMessage(int conversationId, String content, int userId, {String? type, String? url}) async {
    return await remoteDataSource.sendMessage(conversationId, content, userId, type: type, url: url);
  }

  @override
  Future<Conversation> createConversation(int otherUserId) {
    return remoteDataSource.createConversation(otherUserId);
  }

  @override
  Future<Conversation> createGroupConversation(List<int> participantIds, String name) {
    return remoteDataSource.createGroupConversation(participantIds, name);
  }
}

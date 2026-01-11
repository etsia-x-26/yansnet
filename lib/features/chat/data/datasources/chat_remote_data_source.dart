import '../../../../core/network/api_client.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../models/conversation_dto.dart';
import '../models/message_dto.dart';

abstract class ChatRemoteDataSource {
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessages(int conversationId);
  Future<Message> sendMessage(int conversationId, String content);
  Future<Conversation> createConversation(int otherUserId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Conversation>> getConversations() async {
    final response = await apiClient.dio.get('/api/conversations');
    final List data = response.data;
    return data.map((e) => ConversationDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<List<Message>> getMessages(int conversationId) async {
    final response = await apiClient.dio.get('/api/conversations/$conversationId/messages');
    final List data = response.data;
    return data.map((e) => MessageDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<Message> sendMessage(int conversationId, String content) async {
    final response = await apiClient.dio.post('/api/conversations/$conversationId/messages', data: {
      'content': content,
    });
    return MessageDto.fromJson(response.data).toEntity();
  }

  @override
  Future<Conversation> createConversation(int otherUserId) async {
    final response = await apiClient.dio.post('/api/conversations', data: {
      'participantId': otherUserId, // API spec might differ, assuming this
    });
    return ConversationDto.fromJson(response.data).toEntity();
  }
}

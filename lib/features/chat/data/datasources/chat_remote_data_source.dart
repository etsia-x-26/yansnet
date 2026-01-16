import '../../../../core/network/api_client.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../models/conversation_dto.dart';
import '../models/message_dto.dart';

abstract class ChatRemoteDataSource {
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessages(int conversationId);
  Future<Message> sendMessage(int conversationId, String content, int userId, {String? type, String? url});
  Future<Conversation> createConversation(int otherUserId);
  Future<Conversation> createGroupConversation(List<int> participantIds, String name);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Conversation>> getConversations() async {
    final response = await apiClient.dio.get('/api/messages/conversations');
    final Map<String, dynamic> responseData = response.data;
    // Handle paginated response structure if present
    List data;
    if (responseData.containsKey('content')) {
      data = responseData['content'];
    } else {
      // Fallback if not paginated or different structure
      data = responseData as List; 
    }
    return data.map((e) => ConversationDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<List<Message>> getMessages(int conversationId) async {
    final response = await apiClient.dio.get('/api/messages/conversations/$conversationId/messages');
    final Map<String, dynamic> responseData = response.data;
    List data;
    if (responseData.containsKey('content')) {
      data = responseData['content'];
    } else {
      data = responseData as List;
    }
    return data.map((e) => MessageDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<Message> sendMessage(int conversationId, String content, int userId, {String? type, String? url}) async {
    final response = await apiClient.dio.post('/api/messages/send', data: {
      'conversationId': conversationId,
      'content': content,
      'userId': userId,
      'type': type ?? 'TEXT',
      if (url != null) 'url': url,
    });
    return MessageDto.fromJson(response.data).toEntity();
  }

  @override
  Future<Conversation> createConversation(int otherUserId) async {
    final response = await apiClient.dio.post('/api/messages/conversations', data: {
      'participantIds': [otherUserId],
      'type': 'PRIVATE',
      'title': 'New Chat',
      'description': 'Direct Message',
    });
    return ConversationDto.fromJson(response.data).toEntity();
  }

  @override
  Future<Conversation> createGroupConversation(List<int> participantIds, String name) async {
    final response = await apiClient.dio.post('/api/messages/conversations', data: {
      'participantIds': participantIds,
      'type': 'PRIVATE',
      'title': name,
      'description': 'Group Conservation',
    });
    return ConversationDto.fromJson(response.data).toEntity();
  }
}

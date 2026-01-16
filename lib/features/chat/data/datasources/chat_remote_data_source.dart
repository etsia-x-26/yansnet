import 'package:dio/dio.dart';
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
    // GET /api/messages/conversations - Get user conversations
    print('📥 Loading conversations from API...');

    try {
      // Essayer d'abord l'endpoint /api/messages/conversations
      var response = await apiClient.dio.get('/api/messages/conversations');

      print('🔍 GET /api/messages/conversations response: ${response.data}');
      print('🔍 Response type: ${response.data.runtimeType}');

      List<dynamic> data = response.data is List ? response.data : [];
      print(
        '✅ Found ${data.length} conversations from /api/messages/conversations',
      );

      // Si vide, essayer l'autre endpoint
      if (data.isEmpty) {
        print(
          '⚠️ No conversations from /api/messages/conversations, trying /Conversation',
        );
        try {
          response = await apiClient.dio.get('/Conversation');
          print('🔍 GET /Conversation response: ${response.data}');
          data = response.data is List ? response.data : [];
          print('✅ Found ${data.length} conversations from /Conversation');

          // Pour chaque conversation, récupérer les détails complets avec participants
          List<Map<String, dynamic>> detailedConversations = [];
          for (var conv in data) {
            try {
              final detailResponse = await apiClient.dio.get(
                '/Conversation/${conv['id']}',
              );
              print(
                '🔍 GET /Conversation/${conv['id']} response: ${detailResponse.data}',
              );
              detailedConversations.add(
                detailResponse.data as Map<String, dynamic>,
              );
            } catch (e) {
              print('❌ Error loading conversation ${conv['id']}: $e');
              // Utiliser la conversation sans détails si l'appel échoue
              detailedConversations.add(conv as Map<String, dynamic>);
            }
          }
          data = detailedConversations;
        } catch (e) {
          print('❌ Error from /Conversation: $e');
        }
      }

      final conversations = data
          .map(
            (e) =>
                ConversationDto.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      print('✅ Parsed ${conversations.length} conversations');

      return conversations;
    } catch (e) {
      print('❌ Error loading conversations: $e');
      if (e is DioException) {
        print('❌ Response data: ${e.response?.data}');
        print('❌ Status code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  @override
  Future<List<Message>> getMessages(int conversationId) async {
    // GET /api/messages/conversations/{conversationId}/messages - Get messages
    final response = await apiClient.dio.get(
      '/api/messages/conversations/$conversationId/messages',
    );

    print(
      '🔍 GET /api/messages/conversations/$conversationId/messages response: ${response.data}',
    );

    // L'API retourne un objet paginé avec les messages dans 'content'
    if (response.data is Map && response.data.containsKey('content')) {
      final List data = response.data['content'] ?? [];
      print('📥 Found ${data.length} messages in paginated response');
      return data.map((e) => MessageDto.fromJson(e).toEntity()).toList();
    }

    // Fallback si c'est directement une liste
    final List data = response.data is List ? response.data : [];
    print('📥 Found ${data.length} messages in direct list');
    return data.map((e) => MessageDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<Message> sendMessage(int conversationId, String content) async {
    // POST /api/messages/send - Send message
    final response = await apiClient.dio.post(
      '/api/messages/send',
      data: {'conversationId': conversationId, 'content': content},
    );

    print('🔍 POST /api/messages/send response: ${response.data}');

    return MessageDto.fromJson(response.data).toEntity();
  }

  @override
  Future<Conversation> createConversation(int otherUserId) async {
    // POST /api/messages/conversations - Create conversation
    print('🆕 Creating conversation with user: $otherUserId');

    final payload = {
      'participantIds': [otherUserId],
      'type': 'DIRECT', // Le backend exige un type de conversation
    };

    print('📤 Payload: $payload');

    try {
      final response = await apiClient.dio.post(
        '/api/messages/conversations',
        data: payload,
      );

      print('✅ Conversation created successfully!');
      print('🔍 POST /api/messages/conversations response: ${response.data}');

      return ConversationDto.fromJson(response.data).toEntity();
    } catch (e) {
      print('❌ Error creating conversation: $e');
      if (e is DioException) {
        print('❌ Response data: ${e.response?.data}');
        print('❌ Status code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }
}

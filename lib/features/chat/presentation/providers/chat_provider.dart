import 'package:flutter/material.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/start_chat_usecase.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../auth/domain/auth_domain.dart';

class ChatProvider extends ChangeNotifier {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatUseCase startChatUseCase;
  final WebSocketService webSocketService;
  User? _currentUser;

  List<Conversation> _conversations = [];
  final Map<int, List<Message>> _messages =
  {}; // Cache messages by conversationId
  bool _isLoadingConversations = false;
  bool _isLoadingMessages = false;
  String? _error;

  ChatProvider({
    required this.getConversationsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startChatUseCase,
    required this.webSocketService,
    User? currentUser,
  }) : _currentUser = currentUser {
    _initWebSocket();
  }

  User? get currentUser => _currentUser;

  void updateUser(User? user) {
    if (_currentUser?.id != user?.id) {
      _currentUser = user;
      // Re-connect if user changed
      if (_currentUser != null) {
        webSocketService.disconnect();
        webSocketService.connect(_currentUser!.username ?? _currentUser!.email);
      }
      notifyListeners();
    }
  }

  void _initWebSocket() {
    webSocketService.onMessageReceived = (data) {
      _handleRealTimeMessage(data);
    };
  }

  void _handleRealTimeMessage(Map<String, dynamic> data) {
    // According to guide: content, sender, type (CHAT, JOIN, LEAVE, TYPING), timestamp
    final type = data['type'];
    final content = data['content'];
    final sender = data['sender'];

    if (type == 'CHAT' && content != null) {
      // In a real app, you'd match this to a conversation.
      // For public chat demonstration, we can just log it or add to a specific global conv.
      print('[ChatProvider] Received real-time message from $sender: $content');

      // If we had a "Public Chat" conversation, we'd add it there.
      // For now, let's notify listeners to let UI respond.
      notifyListeners();
    }
  }

  List<Conversation> get conversations => _conversations;
  bool get isLoadingConversations => _isLoadingConversations;
  bool get isLoadingMessages => _isLoadingMessages;
  String? get error => _error;

  List<Message> getMessages(int conversationId) {
    return _messages[conversationId] ?? [];
  }

  Future<void> loadConversations() async {
    _isLoadingConversations = true;
    _error = null;
    notifyListeners();

    try {
      _conversations = await getConversationsUseCase();

      // Connect to WebSocket if not already connected (redundant if updateUser handled it, but safe)
      if (_currentUser != null) {
        webSocketService.connect(_currentUser!.username ?? _currentUser!.email);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingConversations = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(int conversationId) async {
    _isLoadingMessages = true;
    // Don't clear existing messages to avoid flicker
    notifyListeners();

    try {
      final messages = await getMessagesUseCase(conversationId);
      _messages[conversationId] = messages;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(int conversationId, String content) async {
    print('📤 ChatProvider.sendMessage called');
    print('📤 Conversation ID: $conversationId');
    print('📤 Content: $content');

    // Optimistic reading locally could be complex with IDs, so we wait for server
    try {
      final newMessage = await sendMessageUseCase(conversationId, content);
      print('✅ Message sent, received: ${newMessage.id}');

      // Add to message list
      final currentList = _messages[conversationId] ?? [];
      _messages[conversationId] = [...currentList, newMessage]; // Append

      // Update last message in conversation list if exists
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        final oldConv = _conversations[index];
        _conversations[index] = Conversation(
          id: oldConv.id,
          participants: oldConv.participants,
          lastMessage: newMessage,
          unreadCount: 0, // Reset unread since we sent it
        );
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error in ChatProvider.sendMessage: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Conversation?> startChat(int otherUserId) async {
    print('🆕 ChatProvider.startChat called with userId: $otherUserId');
    try {
      final conversation = await startChatUseCase(otherUserId);
      print('✅ Conversation created: ${conversation.id}');

      // Check if already exists in list
      if (!_conversations.any((c) => c.id == conversation.id)) {
        _conversations.insert(0, conversation);
        print('✅ Added conversation to list');
      } else {
        print('ℹ️ Conversation already in list');
      }
      notifyListeners();
      return conversation;
    } catch (e) {
      print('❌ Error in ChatProvider.startChat: $e');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Conversation?> startGroupChat(List<int> participantIds, String groupName) async {
    print('🆕 ChatProvider.startGroupChat called');
    print('🆕 Participants: $participantIds');
    print('🆕 Group name: $groupName');

    try {
      // Pour l'instant, on utilise startChatUseCase avec le premier participant
      // TODO: Créer un vrai use case pour les groupes quand le backend sera prêt
      final conversation = await startChatUseCase(participantIds.first);
      print('✅ Group conversation created: ${conversation.id}');

      // Check if already exists in list
      if (!_conversations.any((c) => c.id == conversation.id)) {
        _conversations.insert(0, conversation);
        print('✅ Added group conversation to list');
      } else {
        print('ℹ️ Group conversation already in list');
      }
      notifyListeners();
      return conversation;
    } catch (e) {
      print('❌ Error in ChatProvider.startGroupChat: $e');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}


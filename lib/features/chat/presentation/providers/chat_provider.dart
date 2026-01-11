import 'package:flutter/material.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/start_chat_usecase.dart';

class ChatProvider extends ChangeNotifier {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatUseCase startChatUseCase;

  List<Conversation> _conversations = [];
  Map<int, List<Message>> _messages = {}; // Cache messages by conversationId
  bool _isLoadingConversations = false;
  bool _isLoadingMessages = false;
  String? _error;

  ChatProvider({
    required this.getConversationsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startChatUseCase,
  });

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
    // Optimistic reading locally could be complex with IDs, so we wait for server
    try {
      final newMessage = await sendMessageUseCase(conversationId, content);
      
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
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Conversation?> startChat(int otherUserId) async {
    try {
      final conversation = await startChatUseCase(otherUserId);
      
      // Check if already exists in list
      if (!_conversations.any((c) => c.id == conversation.id)) {
        _conversations.insert(0, conversation);
      }
      notifyListeners();
      return conversation;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}

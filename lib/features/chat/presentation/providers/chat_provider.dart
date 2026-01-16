import 'package:flutter/material.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/models/message_dto.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import 'dart:io';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/start_chat_usecase.dart';
import '../../domain/usecases/create_group_conversation_usecase.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../auth/domain/auth_domain.dart';
import '../../../media/domain/usecases/upload_file_usecase.dart';

class ChatProvider extends ChangeNotifier {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatUseCase startChatUseCase;
  final CreateGroupConversationUseCase createGroupConversationUseCase;
  final WebSocketService webSocketService;
  final UploadFileUseCase uploadFileUseCase;
  User? _currentUser;

  List<Conversation> _conversations = [];
  final Map<int, List<Message>> _messages = {}; // Cache messages by conversationId
  bool _isLoadingConversations = false;
  bool _isLoadingMessages = false;
  String? _error;

  ChatProvider({
    required this.getConversationsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startChatUseCase,
    required this.createGroupConversationUseCase,
    required this.webSocketService,
    required this.uploadFileUseCase,
    User? currentUser,
  }) : _currentUser = currentUser {
    _initWebSocket();
  }

  Future<Conversation?> createGroup(List<int> participantIds, String name) async {
    try {
      final conversation = await createGroupConversationUseCase(participantIds, name);
      _conversations.insert(0, conversation);
      notifyListeners();
      return conversation;
    } catch (e) {
      print(e);
      return null;
    }
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
    // According to guide: type='CHAT', and payload matches MessageDto
    final type = data['type'];

    if (type == 'CHAT') {
      try {
        // Assume data contains message fields directly or inside 'payload'
        // For now, let's assume 'content' and other fields are at top level or we try to parse it.
        // If data has 'payload', use that.
        final payload = data.containsKey('payload') ? data['payload'] : data;
        
        final messageDto = MessageDto.fromJson(payload);
        final message = messageDto.toEntity();

        // 1. Update Conversation List (Move to top, update last message)
        final convIndex = _conversations.indexWhere((c) => c.id == message.conversationId);
        if (convIndex != -1) {
           final oldConv = _conversations[convIndex];
           
           // Only increment unread if we are not currently viewing it (naive check)
           // ideally we rely on server for unread, but for real-time we can increment
           int unread = oldConv.unreadCount + 1;
           if (currentUser?.id == message.senderId) unread = 0; // If I sent it (e.g. from another device)

           _conversations[convIndex] = Conversation(
             id: oldConv.id,
             participants: oldConv.participants,
             type: oldConv.type,
             title: oldConv.title,
             lastMessage: message,
             unreadCount: unread,
           );
           
           // Move to top
           final updatedConv = _conversations.removeAt(convIndex);
           _conversations.insert(0, updatedConv);
        } else {
          // New conversation? Fetch lists again to be safe
          loadConversations();
        }

        // 2. Add to active messages list if this conversation is loaded
        if (_messages.containsKey(message.conversationId)) {
          // Deduplicate
          final existing = _messages[message.conversationId]!;
          if (!existing.any((m) => m.id == message.id)) {
             _messages[message.conversationId] = [...existing, message];
          }
        }

        notifyListeners();
      } catch (e) {
        print('[ChatProvider] Error parsing real-time message: $e');
      }
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

  Future<void> sendMessage(int conversationId, String content, {String? type, String? url}) async {
    if (_currentUser == null) return;

    // Optimistic Update
    final tempId = DateTime.now().millisecondsSinceEpoch; 
    final optimisticMessage = Message(
      id: tempId, 
      conversationId: conversationId, 
      content: content, 
      senderId: _currentUser!.id, 
      createdAt: DateTime.now(),
      type: type,
      url: url,
      status: MessageStatus.sending,
    );

    _messages[conversationId] = [...(_messages[conversationId] ?? []), optimisticMessage];
    
    // Update conversation preview immediately
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final oldConv = _conversations[convIndex];
      _conversations[convIndex] = Conversation(
         id: oldConv.id,
         participants: oldConv.participants,
         lastMessage: optimisticMessage,
         unreadCount: 0,
         type: oldConv.type,
         title: oldConv.title,
      );
      // Move to top
      final updatedConv = _conversations.removeAt(convIndex);
      _conversations.insert(0, updatedConv);
    }
    notifyListeners();

    try {
      final newMessage = await sendMessageUseCase(conversationId, content, _currentUser!.id, type: type, url: url);
      
      final currentList = _messages[conversationId] ?? [];
      final index = currentList.indexWhere((m) => m.id == tempId);
      
      if (index != -1) {
        // Check if real message already exists (from websocket)
        final alreadyExists = currentList.any((m) => m.id == newMessage.id);
        if (alreadyExists) {
           // Remove optimistic message since real one is there
           currentList.removeAt(index);
           _messages[conversationId] = List.from(currentList);
        } else {
           // Replace optimistic message
           currentList[index] = newMessage; 
           _messages[conversationId] = List.from(currentList);
        }
      } else {
        // Optimistic message not found (should not happen), just add if not exists
        if (!currentList.any((m) => m.id == newMessage.id)) {
           _messages[conversationId] = [...currentList, newMessage];
        }
      }
      
      // Update Conversation Last Message (Success) with real message
      final cIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (cIndex != -1) {
        final oldConv = _conversations[cIndex];
        _conversations[cIndex] = Conversation(
           id: oldConv.id,
           participants: oldConv.participants,
           lastMessage: newMessage,
           unreadCount: 0,
           type: oldConv.type,
           title: oldConv.title,
        );
      }
      
      notifyListeners();
    } catch (e) {
      print("Send Message Error: $e");
      // Mark as failed
      final currentList = _messages[conversationId] ?? [];
      final index = currentList.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        currentList[index] = Message(
          id: tempId,
          conversationId: conversationId,
          content: content,
          senderId: _currentUser!.id,
          createdAt: optimisticMessage.createdAt,
          type: type,
          url: url,
          status: MessageStatus.failed,
        );
        _messages[conversationId] = List.from(currentList);
        notifyListeners();
      }
      _error = "Failed to send message: $e";
    }
  }

  Future<void> sendMediaMessage(int conversationId, File file, {String type = 'IMAGE'}) async {
    if (_currentUser == null) return;
    
    try {
      // If folder is not supported yet by usecase, we can omit it, or if added, keep it. 
      // Assuming UploadFileUseCase update applied successfully.
      final uploadUrl = await uploadFileUseCase(file, folder: 'chat');
      
      await sendMessage(
        conversationId, 
        type == 'IMAGE' ? 'Sent an image' : 'Sent a video', 
        type: type, 
        url: uploadUrl
      );
    } catch (e) {
      _error = "Failed to send media: $e";
      notifyListeners();
    }
  }


  Future<Conversation?> startChat(int otherUserId) async {
    try {
      // Check if conversation already exists locally first
      // Note: 'type' might be on the entity, checking implementation...
      // If entity doesn't have 'type', we relies on participants.
      
      // Assuming Conversation entity has 'type' field as per error log. 
      // If NOT, we need to check the Entity definition. 
      // For now, I'll assume the error "getter 'type' isn't defined" means I need to fix Entity or check differently.
      // But first let's fix the syntax error of 'return null } }'.
      
      /* 
         The previous error said: 
         lib/features/chat/presentation/providers/chat_provider.dart:211:62: Error: No named parameter with the name 'type'.
         orElse: () => Conversation(id: -1, participants: [], type: '', unreadCount: 0),
         
         So Conversation constructor does NOT have 'type'.
      */

      final existing = _conversations.firstWhere(
        (c) => c.participants.any((p) => p.id == otherUserId) && c.participants.length == 2,
        orElse: () => Conversation(id: -1, participants: [], unreadCount: 0), 
      );

      if (existing.id != -1) {
        return existing;
      }

      final conversation = await startChatUseCase(otherUserId);
      
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

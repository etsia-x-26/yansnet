import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/auth/domain/auth_domain.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import '../features/chat/domain/entities/message_entity.dart';

class InstagramChatScreen extends StatefulWidget {
  final User recipientUser;
  final bool isGroup;
  final String? groupName;
  final List<User>? groupMembers;
  final int? conversationId;

  const InstagramChatScreen({
    super.key,
    required this.recipientUser,
    this.isGroup = false,
    this.groupName,
    this.groupMembers,
    this.conversationId,
  });

  @override
  State<InstagramChatScreen> createState() => _InstagramChatScreenState();
}

class _InstagramChatScreenState extends State<InstagramChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _currentConversationId;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeConversation();
    });
  }

  Future<void> _initializeConversation() async {
    print('🔄 Initializing conversation...');
    print('🔄 Conversation ID from widget: ${widget.conversationId}');
    print('🔄 Is group: ${widget.isGroup}');
    print('🔄 Recipient user ID: ${widget.recipientUser.id}');

    if (_currentConversationId != null) {
      // Load existing conversation messages
      print('📥 Loading messages for conversation $_currentConversationId');
      await context.read<ChatProvider>().loadMessages(_currentConversationId!);
      _scrollToBottom();
    } else if (!widget.isGroup) {
      // Start new 1-to-1 conversation
      print('🆕 Starting new chat with user ${widget.recipientUser.id}');
      setState(() => _isInitializing = true);

      try {
        final conversation = await context.read<ChatProvider>().startChat(
          widget.recipientUser.id,
        );

        if (conversation != null && mounted) {
          print('✅ Conversation created: ID=${conversation.id}');
          setState(() {
            _currentConversationId = conversation.id;
            _isInitializing = false;
          });
          await context.read<ChatProvider>().loadMessages(conversation.id);
          _scrollToBottom();
        } else {
          print('❌ Failed to create conversation - conversation is null');
          setState(() => _isInitializing = false);
        }
      } catch (e) {
        print('❌ Error creating conversation: $e');
        setState(() => _isInitializing = false);
      }
    } else {
      print('⚠️ Group chat - conversation ID should be provided');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    print('🔵 _sendMessage called');
    print('🔵 Message text: ${_messageController.text}');
    print('🔵 Current conversation ID: $_currentConversationId');

    if (_messageController.text.trim().isEmpty) {
      print('❌ Message is empty');
      return;
    }

    if (_currentConversationId == null) {
      print('❌ Conversation ID is null - trying to create conversation');
      setState(() => _isInitializing = true);

      if (!widget.isGroup) {
        // Create 1-to-1 conversation
        final conversation = await context.read<ChatProvider>().startChat(
          widget.recipientUser.id,
        );
        if (conversation != null && mounted) {
          setState(() {
            _currentConversationId = conversation.id;
            _isInitializing = false;
          });
          print('✅ Conversation created with ID: $_currentConversationId');
        } else {
          setState(() => _isInitializing = false);
          print('❌ Failed to create conversation');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Impossible de créer la conversation',
                style: GoogleFonts.plusJakartaSans(),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      } else {
        // Create group conversation
        print('🆕 Creating group conversation');
        print(
          '🆕 Group members: ${widget.groupMembers?.map((u) => u.id).toList()}',
        );

        if (widget.groupMembers == null || widget.groupMembers!.isEmpty) {
          print('❌ No group members');
          setState(() => _isInitializing = false);
          return;
        }

        final conversation = await context.read<ChatProvider>().startGroupChat(
          widget.groupMembers!.map((u) => u.id).toList(),
          widget.groupName ?? 'Groupe',
        );

        if (conversation != null && mounted) {
          setState(() {
            _currentConversationId = conversation.id;
            _isInitializing = false;
          });
          print(
            '✅ Group conversation created with ID: $_currentConversationId',
          );
        } else {
          setState(() => _isInitializing = false);
          print('❌ Failed to create group conversation');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Impossible de créer le groupe',
                style: GoogleFonts.plusJakartaSans(),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    final content = _messageController.text.trim();
    _messageController.clear();

    print(
      '📤 Sending message: $content to conversation $_currentConversationId',
    );

    try {
      await context.read<ChatProvider>().sendMessage(
        _currentConversationId!,
        content,
      );
      print('✅ Message sent successfully');
      _scrollToBottom();
    } catch (e) {
      print('❌ Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de l\'envoi: $e',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final chatProvider = context.watch<ChatProvider>();
    final messages = _currentConversationId != null
        ? chatProvider.getMessages(_currentConversationId!)
        : <Message>[];

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1313EC)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Avatar
            if (widget.isGroup)
              Stack(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.group, size: 20, color: Colors.grey[600]),
                  ),
                ],
              )
            else
              CircleAvatar(
                radius: 18,
                backgroundImage: widget.recipientUser.profilePictureUrl != null
                    ? NetworkImage(widget.recipientUser.profilePictureUrl!)
                    : null,
                backgroundColor: Colors.grey[300],
                child: widget.recipientUser.profilePictureUrl == null
                    ? Text(
                  widget.recipientUser.name[0].toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
            const SizedBox(width: 12),
            // Nom
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isGroup
                        ? widget.groupName!
                        : widget.recipientUser.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isGroup)
                    Text(
                      '${widget.groupMembers!.length} membres',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isGroup)
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.group,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                      widget.recipientUser.profilePictureUrl != null
                          ? NetworkImage(
                        widget.recipientUser.profilePictureUrl!,
                      )
                          : null,
                      backgroundColor: Colors.grey[300],
                      child:
                      widget.recipientUser.profilePictureUrl == null
                          ? Text(
                        widget.recipientUser.name[0].toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    widget.isGroup
                        ? widget.groupName!
                        : widget.recipientUser.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isGroup
                        ? 'Dites bonjour à votre nouveau groupe!'
                        : 'Dites bonjour pour commencer la conversation',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMine = message.senderId == currentUser?.id;

                return Align(
                  alignment: isMine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? const Color(0xFF1313EC)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.content,
                      style: GoogleFonts.plusJakartaSans(
                        color: isMine ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Barre de saisie
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.grey[700]),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.photo, color: Colors.grey[700]),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.grey[700]),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF1313EC)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

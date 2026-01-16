import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/chat/presentation/providers/chat_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/chat/domain/entities/message_entity.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../features/chat/domain/entities/conversation_entity.dart';
import '../features/auth/domain/auth_domain.dart';

class ChatDetailScreen extends StatefulWidget {
  final Conversation conversation;
  final User? otherUser;

  const ChatDetailScreen({super.key, required this.conversation, this.otherUser});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMessages(widget.conversation.id).then((_) {
         _scrollToBottom();
      });
    });
    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && mounted) {
      await context.read<ChatProvider>().sendMediaMessage(widget.conversation.id, File(image.path));
      _scrollToBottom();
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(widget.conversation.id, text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final currentUserId = authUser?.id ?? 0;
    final otherUser = widget.otherUser ?? widget.conversation.getOtherUser(currentUserId);
    
    // Determine title: Group name or Other User Name
    final title = widget.conversation.type == 'GROUP' 
        ? (widget.conversation.title ?? "Group Chat") 
        : (otherUser?.name ?? "Chat");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Clean Background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1313EC), // Primary Blue
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, size: 24),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: otherUser?.profilePictureUrl != null && otherUser!.profilePictureUrl!.isNotEmpty
                  ? NetworkImage(otherUser.profilePictureUrl!)
                  : null,
                child: (otherUser?.profilePictureUrl == null || otherUser!.profilePictureUrl!.isEmpty) && widget.conversation.type != 'GROUP'
                  ? Text(title.isNotEmpty ? title[0].toUpperCase() : '?', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))
                  : (widget.conversation.type == 'GROUP' ? const Icon(Icons.group, size: 16, color: Colors.white) : null),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        color: const Color(0xFFF8F9FA), 
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  final messages = provider.getMessages(widget.conversation.id);
                  // NO REVERSE
                  
                  if (provider.isLoadingMessages && messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF1313EC)));
                  }

                  if (messages.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text("Send a message to start chatting!", style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[600])),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false, // Top to Bottom
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == currentUserId;
                      final isGroup = widget.conversation.type == 'GROUP';
                      
                      // Date Header Logic (Previous date check)
                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        final prevMessage = messages[index - 1];
                        if (message.createdAt.day != prevMessage.createdAt.day) {
                          showDateHeader = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showDateHeader) _buildDateHeader(message.createdAt),
                          _buildMessageBubble(message, isMe, isGroup),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    String text;
    if (now.day == date.day && now.month == date.month && now.year == date.year) {
      text = "Today";
    } else if (now.difference(date).inDays < 2 && now.day - date.day == 1) {
      text = "Yesterday";
    } else {
      text = "${date.day}/${date.month}/${date.year}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, bool isGroup) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1313EC) : Colors.white, // Blue vs White
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isGroup && !isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                     widget.conversation.getParticipant(message.senderId)?.name ?? "User ${message.senderId}", 
                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: const Color(0xFF1313EC), fontSize: 12),
                  ),
                ),

              if (message.type == 'IMAGE' && message.url != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: message.url!,
                      placeholder: (c, u) => Container(
                        height: 150, width: 200, color: Colors.grey[100], child: const Center(child: CircularProgressIndicator())
                      ),
                      errorWidget: (c, u, e) => const Icon(Icons.broken_image, color: Colors.grey),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 8,
                children: [
                  Text(
                    message.content,
                    style: GoogleFonts.plusJakartaSans(
                      color: isMe ? Colors.white : const Color(0xFF1A1D1E), // White text on Blue
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, 
                            color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(message.status, isMe),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status, bool isMe) {
    // Icons need to be white since they are on Blue background
    final color = isMe ? Colors.white.withOpacity(0.9) : Colors.grey; 
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time_rounded, size: 12, color: color);
      case MessageStatus.sent:
        return Icon(Icons.done_all_rounded, size: 14, color: color); 
      case MessageStatus.failed:
        return const Icon(Icons.error_outline_rounded, size: 14, color: Colors.redAccent);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF0F2F5), shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Color(0xFF1313EC), size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: GoogleFonts.plusJakartaSans(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                          isDense: true,
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined, color: Colors.grey[500], size: 20),
                      onPressed: _pickImage,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isComposing ? const Color(0xFF1313EC) : const Color(0xFFF0F2F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isComposing ? Icons.send_rounded : Icons.mic_none_rounded, 
                  color: _isComposing ? Colors.white : Colors.grey[500], 
                  size: 20
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

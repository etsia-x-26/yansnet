import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/chat/domain/entities/enhanced_message_entity.dart';

class ConversationTile extends StatelessWidget {
  final EnhancedConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 4),
                      _buildLastMessage(),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTimestamp(),
                    const SizedBox(height: 4),
                    _buildBadges(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.type == ConversationType.group) {
      return _buildGroupAvatar();
    }

    final otherUser = conversation.getOtherUser(0);
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: otherUser?.profilePictureUrl != null
              ? NetworkImage(otherUser!.profilePictureUrl!)
              : const AssetImage('assets/images/onboarding_welcome.png')
                    as ImageProvider,
        ),
        if (conversation.isPinned)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFF1313EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.push_pin, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildGroupAvatar() {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            image: conversation.groupImageUrl != null
                ? DecorationImage(
                    image: NetworkImage(conversation.groupImageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: conversation.groupImageUrl == null
              ? Icon(Icons.group, size: 28, color: Colors.grey[600])
              : null,
        ),
        if (conversation.isPinned)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFF1313EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.push_pin, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.displayName,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (conversation.isMuted)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.notifications_off,
              size: 16,
              color: Colors.grey[500],
            ),
          ),
        if (conversation.type == ConversationType.group)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(Icons.group, size: 16, color: Colors.grey[500]),
          ),
      ],
    );
  }

  Widget _buildLastMessage() {
    if (conversation.lastMessage == null) {
      return Text(
        'No messages yet',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      );
    }

    final message = conversation.lastMessage!;
    String messageText = '';

    switch (message.type) {
      case MessageType.text:
        messageText = message.content;
        break;
      case MessageType.image:
        messageText = '📷 Photo';
        break;
      case MessageType.video:
        messageText = '🎥 Video';
        break;
      case MessageType.audio:
        messageText = '🎵 Audio';
        break;
      case MessageType.location:
        messageText = '📍 Location';
        break;
      case MessageType.sticker:
        messageText = '😊 Sticker';
        break;
      case MessageType.reply:
        messageText = 'Replied to a message';
        break;
      case MessageType.story_reply:
        messageText = 'Replied to your story';
        break;
    }

    return Row(
      children: [
        if (message.status == MessageStatus.sending)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[400],
              ),
            ),
          ),
        if (message.status == MessageStatus.sent)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.check, size: 14, color: Colors.grey[500]),
          ),
        if (message.status == MessageStatus.delivered)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.done_all, size: 14, color: Colors.grey[500]),
          ),
        if (message.status == MessageStatus.read)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.done_all,
              size: 14,
              color: const Color(0xFF1313EC),
            ),
          ),
        Expanded(
          child: Text(
            messageText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: conversation.unreadCount > 0
                  ? Colors.black
                  : Colors.grey[600],
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimestamp() {
    if (conversation.lastMessage == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final messageTime = conversation.lastMessage!.createdAt;
    final difference = now.difference(messageTime);

    String timeText;
    if (difference.inDays > 0) {
      timeText = '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      timeText = '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      timeText = '${difference.inMinutes}m';
    } else {
      timeText = 'now';
    }

    return Text(
      timeText,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: conversation.unreadCount > 0
            ? const Color(0xFF1313EC)
            : Colors.grey[500],
        fontWeight: conversation.unreadCount > 0
            ? FontWeight.w600
            : FontWeight.normal,
      ),
    );
  }

  Widget _buildBadges() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (conversation.unreadCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: const BoxDecoration(
              color: Color(0xFF1313EC),
              shape: BoxShape.circle,
            ),
            child: Text(
              conversation.unreadCount > 99
                  ? '99+'
                  : conversation.unreadCount.toString(),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

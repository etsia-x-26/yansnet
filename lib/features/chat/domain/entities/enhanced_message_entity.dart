import '../../../auth/domain/auth_domain.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  location,
  sticker,
  reply,
  story_reply,
}

enum MessageStatus { sending, sent, delivered, read, failed }

class EnhancedMessage {
  final int id;
  final int conversationId;
  final String content;
  final int senderId;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final MessageType type;
  final MessageStatus status;
  final bool isRead;
  final Map<String, int> reactions; // emoji -> count
  final List<String> mediaUrls;
  final int? replyToMessageId;
  final EnhancedMessage? replyToMessage;
  final Map<String, dynamic>? metadata; // For location, stickers, etc.

  EnhancedMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.isRead = false,
    this.reactions = const {},
    this.mediaUrls = const [],
    this.replyToMessageId,
    this.replyToMessage,
    this.metadata,
  });

  bool get isDeleted => deletedAt != null;
  bool get isEdited => editedAt != null;
  bool get hasReactions => reactions.isNotEmpty;
  bool get hasMedia => mediaUrls.isNotEmpty;
  bool get isReply => replyToMessageId != null;
}

enum ConversationType { direct, group, channel }

class EnhancedConversation {
  final int id;
  final String? name; // For group chats
  final String? description;
  final List<User> participants;
  final EnhancedMessage? lastMessage;
  final int unreadCount;
  final ConversationType type;
  final String? groupImageUrl;
  final bool isMuted;
  final bool isPinned;
  final DateTime? lastSeen;
  final List<int> admins; // User IDs who are admins
  final bool isArchived;

  EnhancedConversation({
    required this.id,
    this.name,
    this.description,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.type = ConversationType.direct,
    this.groupImageUrl,
    this.isMuted = false,
    this.isPinned = false,
    this.lastSeen,
    this.admins = const [],
    this.isArchived = false,
  });

  User? getOtherUser(int currentUserId) {
    if (type != ConversationType.direct) return null;
    try {
      return participants.firstWhere((u) => u.id != currentUserId);
    } catch (_) {
      return null;
    }
  }

  bool isAdmin(int userId) => admins.contains(userId);
  String get displayName => name ?? getOtherUser(0)?.name ?? 'Unknown';
}

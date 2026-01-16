
enum MessageStatus { sent, sending, failed }

class Message {
  final int id;
  final int conversationId;
  final String content;
  final int senderId; // ID only for simplicity, or full User object
  final DateTime createdAt;
  final bool isRead;
  final String? type; // 'TEXT', 'IMAGE', 'VIDEO'
  final String? url;
  final MessageStatus status;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.isRead = false,
    this.type,
    this.url,
    this.status = MessageStatus.sent,
  });
}

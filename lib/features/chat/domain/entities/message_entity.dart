import '../../../auth/domain/auth_domain.dart';

class Message {
  final int id;
  final int conversationId;
  final String content;
  final int senderId; // ID only for simplicity, or full User object
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.isRead = false,
  });
}

import '../../domain/entities/message_entity.dart';

class MessageDto {
  final int id;
  final int conversationId;
  final String content;
  final int senderId;
  final DateTime createdAt;
  final bool isRead;

  MessageDto({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['id'] ?? 0,
      conversationId: json['conversationId'] ?? 0,
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isRead: json['read'] ?? false,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      content: content,
      senderId: senderId,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

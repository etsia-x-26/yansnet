import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../../auth/data/datasources/auth_remote_data_source.dart'; // To reuse User DTO logic if needed, or simply map fields
import '../../../../models/user_model.dart' as u_model; 
import '../../../auth/domain/auth_domain.dart';
import 'message_dto.dart';

class ConversationDto {
  final int id;
  final List<u_model.User> participants;
  final MessageDto? lastMessage;
  final int unreadCount;

  ConversationDto({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
     return ConversationDto(
       id: json['id'] ?? 0,
       participants: (json['participants'] as List?)
           ?.map((e) => u_model.User.fromJson(e))
           .toList() ?? [],
       lastMessage: json['lastMessage'] != null 
          ? MessageDto.fromJson(json['lastMessage']) 
          : null,
       unreadCount: json['unreadCount'] ?? 0,
     );
  }

  Conversation toEntity() {
    return Conversation(
      id: id,
      participants: participants.map((e) => User(
        id: e.id,
        email: e.email,
        name: e.name,
        username: e.username,
        bio: e.bio,
        profilePictureUrl: e.profilePictureUrl,
        isMentor: e.isMentor
      )).toList(),
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
    );
  }
}

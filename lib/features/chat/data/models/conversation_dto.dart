import '../../domain/entities/conversation_entity.dart';
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
    print('🔍 Parsing ConversationDto from: $json');

    // Parse participants - l'API retourne userId au lieu de id
    List<u_model.User> parsedParticipants = [];
    if (json['participants'] != null) {
      for (var participantJson in json['participants']) {
        print('🔍 Parsing participant: $participantJson');

        // Mapper userId -> id et avatarUrl -> profilePictureUrl
        final mappedJson = {
          'id': participantJson['userId'] ?? participantJson['id'] ?? 0,
          'email': participantJson['email'] ?? '',
          'name': participantJson['name'] ?? 'Unknown',
          'username': participantJson['username'],
          'bio': participantJson['bio'],
          'profilePictureUrl':
              participantJson['avatarUrl'] ??
              participantJson['profilePictureUrl'],
          'isMentor': participantJson['isMentor'] ?? false,
        };

        parsedParticipants.add(u_model.User.fromJson(mappedJson));
      }
    }

    print('✅ Parsed ${parsedParticipants.length} participants');

    return ConversationDto(
      id: json['id'] ?? 0,
      participants: parsedParticipants,
      lastMessage: json['lastMessage'] != null
          ? MessageDto.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Conversation toEntity() {
    return Conversation(
      id: id,
      participants: participants
          .map(
            (e) => User(
              id: e.id,
              email: e.email,
              name: e.name,
              username: e.username,
              bio: e.bio,
              profilePictureUrl: e.profilePictureUrl,
              isMentor: e.isMentor,
            ),
          )
          .toList(),
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
    );
  }
}

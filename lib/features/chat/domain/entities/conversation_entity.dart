import '../../../auth/domain/auth_domain.dart';
import 'message_entity.dart';

class Conversation {
  final int id;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
  });
  
  // Helper to get 'other' user for display (assuming 1-on-1 for now)
  User? getOtherUser(int currentUserId) {
    try {
      return participants.firstWhere((u) => u.id != currentUserId);
    } catch (_) {
      return null; // Should not happen in 1-on-1
    }
  }
}

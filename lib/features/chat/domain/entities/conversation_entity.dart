import '../../../auth/domain/auth_domain.dart';
import 'message_entity.dart';

class Conversation {
  final int id;
  final List<User> participants;
  final Message? lastMessage;
  final String type;
  final String? title;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.participants,
    this.type = 'PRIVATE',
    this.title,
    this.lastMessage,
    this.unreadCount = 0,
  });
  
  // Helper to get 'other' user for display (assuming 1-on-1 for now)
  User? getOtherUser(int currentUserId) {
    if (participants.isEmpty) return null;
    
    // For PRIVATE chats
    if (type != 'GROUP' && participants.length == 2) {
      if (currentUserId <= 0) {
        // If we don't have a valid current ID, we can't reliably pick 'other'.
        // However, in a private chat of 2, if we don't know who "I" am, 
        // we can't be sure. BUT if the caller is just trying to find some name to show,
        // and they haven't logged in fully, any participant is better than none.
        // Usually, the first one is fine as a fallback, but let's try to be smarter.
        return participants.first;
      }
      
      try {
        return participants.firstWhere((u) => u.id != currentUserId);
      } catch (_) {
        // If current user is for some reason NOT in the participants (e.g. data sync issue),
        // return the first available participant.
        return participants.first;
      }
    }
    
    // For Groups or other cases
    if (type == 'GROUP') {
      try {
        return participants.firstWhere((u) => u.id != currentUserId);
      } catch (_) {
        return participants.isNotEmpty ? participants.first : null;
      }
    }
    
    // Generic fallback
    try {
      return participants.firstWhere((u) => u.id != currentUserId);
    } catch (_) {
      return participants.isNotEmpty ? participants.first : null;
    }
  }

  User? getParticipant(int userId) {
    try {
      return participants.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }
}

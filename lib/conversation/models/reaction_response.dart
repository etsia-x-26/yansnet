// lib/conversation/models/reaction_response.dart
class ReactionResponse {
  final bool success;
  final int newLikeCount;

  ReactionResponse({
    required this.success,
    required this.newLikeCount,
  });
}
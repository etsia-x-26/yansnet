import '../../../auth/domain/auth_domain.dart';

class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  final User? user;
  final int totalLikes;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.user,
    this.totalLikes = 0,
  });
}

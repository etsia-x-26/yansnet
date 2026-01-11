import '../../../auth/domain/auth_domain.dart';
import '../../../../features/channels/domain/entities/channel_entity.dart'; // Import User entity

class Post {
  final int id;
  final String content;
  final DateTime createdAt;
  final User? user;
  final Channel? channel;
  final List<Media> media;
  final int totalLikes;
  final int totalComments;

  Post({
    required this.id,
    required this.content,
    required this.createdAt,
    this.user,
    this.channel,
    this.media = const [],
    this.totalLikes = 0,
    this.totalComments = 0,
  });
}



class Media {
  final int id;
  final String url;
  final String type; // IMAGE, VIDEO

  Media({required this.id, required this.url, required this.type});
}

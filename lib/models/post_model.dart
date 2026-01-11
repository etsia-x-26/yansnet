import 'user_model.dart';

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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      channel: json['channel'] != null ? Channel.fromJson(json['channel']) : null,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e))
              .toList() ??
          [],
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
    );
  }
}

class Channel {
  final int id;
  final String title;
  final String description;
  final int totalFollowers;

  Channel({
    required this.id,
    required this.title,
    required this.description,
    this.totalFollowers = 0,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalFollowers: json['totalFollowers'] ?? 0,
    );
  }
}

class Media {
  final int id;
  final String url;
  final String type; // IMAGE, VIDEO

  Media({required this.id, required this.url, required this.type});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      type: json['type'] ?? 'IMAGE',
    );
  }
}

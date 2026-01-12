// lib/conversation/models/channel_post.dart
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'media.dart';
import 'channel.dart';

part 'channel_post.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ChannelPost {
  final int id;
  final String? content;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final User? user;
  final Channel? channel;
  final List<Media>? media;
  @JsonKey(name: 'totalLikes')
  final int likeCount;
  @JsonKey(name: 'totalComments')
  final int commentCount;
  final bool isLiked; // À gérer côté client

  ChannelPost({
    required this.id,
    this.content,
    this.createdAt,
    this.deletedAt,
    this.user,
    this.channel,
    this.media,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });

  factory ChannelPost.fromJson(Map<String, dynamic> json) {
    return ChannelPost(
      id: json['id'] as int,
      content: json['content'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      channel: json['channel'] != null
          ? Channel.fromJson(json['channel'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null
          ? (json['media'] as List)
          .map((m) => Media.fromJson(m as Map<String, dynamic>))
          .toList()
          : null,
      likeCount: json['totalLikes'] as int? ?? 0,
      commentCount: json['totalComments'] as int? ?? 0,
      isLiked: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'createdAt': createdAt?.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'user': user?.toJson(),
    'channel': channel?.toJson(),
    'media': media?.map((m) => m.toJson()).toList(),
    'totalLikes': likeCount,
    'totalComments': commentCount,
  };

  bool get isDeleted => deletedAt != null;

  ChannelPost copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
    DateTime? deletedAt,
    User? user,
    Channel? channel,
    List<Media>? media,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
  }) {
    return ChannelPost(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      user: user ?? this.user,
      channel: channel ?? this.channel,
      media: media ?? this.media,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
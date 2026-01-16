import '../../domain/entities/channel_entity.dart';

class ChannelDto {
  final int id;
  final String title;
  final String description;
  final int totalFollowers;
  final bool isFollowing;

  ChannelDto({
    required this.id,
    required this.title,
    required this.description,
    this.totalFollowers = 0,
    this.isFollowing = false,
  });

  factory ChannelDto.fromJson(Map<String, dynamic> json) {
    return ChannelDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalFollowers: json['followersCount'] ?? json['totalFollowers'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
    );
  }

  Channel toEntity() {
    return Channel(
      id: id,
      title: title,
      description: description,
      totalFollowers: totalFollowers,
      isFollowing: isFollowing,
    );
  }
}

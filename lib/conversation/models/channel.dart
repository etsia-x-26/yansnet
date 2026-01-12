// lib/conversation/models/channel.dart
import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Channel {
  final int id;
  final String? name;
  final String? description;
  @JsonKey(name: 'profileImageUrl')
  final String? avatar;
  @JsonKey(name: 'totalFollowers')
  final int subscriberCount;
  final bool isSubscribed; // À gérer côté client
  final bool isOfficial; // À gérer côté client
  final String? field;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Channel({
    required this.id,
    this.name,
    this.description,
    this.avatar,
    this.subscriberCount = 0,
    this.isSubscribed = false,
    this.isOfficial = false,
    this.field,
    this.createdAt,
    this.updatedAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    // Adapter la réponse du backend
    return Channel(
      id: json['id'] as int,
      name: json['title'] as String? ?? json['name'] as String?,
      description: json['description'] as String?,
      avatar: json['profileImageUrl'] as String?,
      subscriberCount: json['totalFollowers'] as int? ?? 0,
      isSubscribed: false, // À déterminer
      isOfficial: false, // À déterminer
      field: null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': name,
    'description': description,
    'profileImageUrl': avatar,
    'totalFollowers': subscriberCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  Channel copyWith({
    int? id,
    String? name,
    String? description,
    String? avatar,
    int? subscriberCount,
    bool? isSubscribed,
    bool? isOfficial,
    String? field,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isOfficial: isOfficial ?? this.isOfficial,
      field: field ?? this.field,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

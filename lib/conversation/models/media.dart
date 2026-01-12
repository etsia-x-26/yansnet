// lib/conversation/models/media.dart
import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

enum MediaType {
  @JsonValue('IMAGE')
  image,
  @JsonValue('VIDEO')
  video,
}

@JsonSerializable(explicitToJson: true)
class Media {
  final int? id;
  final String url;
  final DateTime? uploadedAt;
  final MediaType? type;

  Media({
    this.id,
    required this.url,
    this.uploadedAt,
    this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
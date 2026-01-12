import 'package:freezed_annotation/freezed_annotation.dart';

part 'publication_response.freezed.dart';
part 'publication_response.g.dart';

@freezed
class PublicationResponse with _$PublicationResponse {
  const factory PublicationResponse({
    required List<Publication> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _PublicationResponse;

  factory PublicationResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationResponseFromJson(json);
}

@freezed
class Publication with _$Publication {
  const factory Publication({
    required int id,
    required String content,
    required DateTime createdAt,
    required User user,
    required Channel channel,
    DateTime? deletedAt,
    @Default(0) int totalLikes,
    @Default(0) int totalComments,
  }) = _Publication;

  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    int? id,
    String? password,
    bool? isActive,
    String? category,
    bool? isBlocked,
    String? department,
    String? batch,
    String? email,
    String? phoneNumber,
    @Default(0) int totalFollowers,
    @Default(0) int totalFollowing,
    @Default(0) int totalPosts,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Channel with _$Channel {
  const factory Channel({
    int? id,
    String? title,
    String? description,
    @Default(0) int totalFollowers,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
}

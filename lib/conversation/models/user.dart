// lib/conversation/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String? name;
  final String? username;
  final String? description;
  @JsonKey(name: 'urlprofile')
  final String? avatar;
  final Email? email;
  final PhoneNumber? phoneNumber;
  @JsonKey(name: 'totalFollowers')
  final int followerCount;
  @JsonKey(name: 'totalFollowing')
  final int followingCount;
  @JsonKey(name: 'totalPosts')
  final int postCount;

  User({
    required this.id,
    this.name,
    this.username,
    this.description,
    this.avatar,
    this.email,
    this.phoneNumber,
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName => name ?? username ?? 'User #$id';
}

@JsonSerializable()
class Email {
  final String value;
  Email(this.value);
  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}

@JsonSerializable()
class PhoneNumber {
  final String value;
  PhoneNumber(this.value);
  factory PhoneNumber.fromJson(Map<String, dynamic> json) => _$PhoneNumberFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}
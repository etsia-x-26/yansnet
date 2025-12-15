// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicationResponseImpl _$$PublicationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PublicationResponseImpl(
      content: (json['content'] as List<dynamic>)
          .map((e) => Publication.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$$PublicationResponseImplToJson(
        _$PublicationResponseImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };

_$PublicationImpl _$$PublicationImplFromJson(Map<String, dynamic> json) =>
    _$PublicationImpl(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      channel: Channel.fromJson(json['channel'] as Map<String, dynamic>),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      totalLikes: (json['totalLikes'] as num?)?.toInt() ?? 0,
      totalComments: (json['totalComments'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PublicationImplToJson(_$PublicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
      'channel': instance.channel,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'totalLikes': instance.totalLikes,
      'totalComments': instance.totalComments,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num?)?.toInt(),
      password: json['password'] as String?,
      isActive: json['isActive'] as bool?,
      category: json['category'] as String?,
      isBlocked: json['isBlocked'] as bool?,
      department: json['department'] as String?,
      batch: json['batch'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
      totalFollowing: (json['totalFollowing'] as num?)?.toInt() ?? 0,
      totalPosts: (json['totalPosts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'isActive': instance.isActive,
      'category': instance.category,
      'isBlocked': instance.isBlocked,
      'department': instance.department,
      'batch': instance.batch,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'totalFollowers': instance.totalFollowers,
      'totalFollowing': instance.totalFollowing,
      'totalPosts': instance.totalPosts,
    };

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'totalFollowers': instance.totalFollowers,
    };

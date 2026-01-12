// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicationResponseImpl _$$PublicationResponseImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PublicationResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$PublicationResponseImpl(
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>)
                  .map((e) => Publication.fromJson(e as Map<String, dynamic>))
                  .toList()),
          pageNumber: $checkedConvert('page_number', (v) => (v as num).toInt()),
          pageSize: $checkedConvert('page_size', (v) => (v as num).toInt()),
          totalElements:
              $checkedConvert('total_elements', (v) => (v as num).toInt()),
          totalPages: $checkedConvert('total_pages', (v) => (v as num).toInt()),
          last: $checkedConvert('last', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'pageNumber': 'page_number',
        'pageSize': 'page_size',
        'totalElements': 'total_elements',
        'totalPages': 'total_pages'
      },
    );

Map<String, dynamic> _$$PublicationResponseImplToJson(
        _$PublicationResponseImpl instance) =>
    <String, dynamic>{
      'content': instance.content.map((e) => e.toJson()).toList(),
      'page_number': instance.pageNumber,
      'page_size': instance.pageSize,
      'total_elements': instance.totalElements,
      'total_pages': instance.totalPages,
      'last': instance.last,
    };

_$PublicationImpl _$$PublicationImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PublicationImpl',
      json,
      ($checkedConvert) {
        final val = _$PublicationImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          content: $checkedConvert('content', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
          channel: $checkedConvert(
              'channel', (v) => Channel.fromJson(v as Map<String, dynamic>)),
          deletedAt: $checkedConvert('deleted_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          totalLikes:
              $checkedConvert('total_likes', (v) => (v as num?)?.toInt() ?? 0),
          totalComments: $checkedConvert(
              'total_comments', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'deletedAt': 'deleted_at',
        'totalLikes': 'total_likes',
        'totalComments': 'total_comments'
      },
    );

Map<String, dynamic> _$$PublicationImplToJson(_$PublicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'user': instance.user.toJson(),
      'channel': instance.channel.toJson(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'total_likes': instance.totalLikes,
      'total_comments': instance.totalComments,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$UserImpl',
      json,
      ($checkedConvert) {
        final val = _$UserImpl(
          id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
          password: $checkedConvert('password', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
          category: $checkedConvert('category', (v) => v as String?),
          isBlocked: $checkedConvert('is_blocked', (v) => v as bool?),
          department: $checkedConvert('department', (v) => v as String?),
          batch: $checkedConvert('batch', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          phoneNumber: $checkedConvert('phone_number', (v) => v as String?),
          totalFollowers: $checkedConvert(
              'total_followers', (v) => (v as num?)?.toInt() ?? 0),
          totalFollowing: $checkedConvert(
              'total_following', (v) => (v as num?)?.toInt() ?? 0),
          totalPosts:
              $checkedConvert('total_posts', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'isActive': 'is_active',
        'isBlocked': 'is_blocked',
        'phoneNumber': 'phone_number',
        'totalFollowers': 'total_followers',
        'totalFollowing': 'total_following',
        'totalPosts': 'total_posts'
      },
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'is_active': instance.isActive,
      'category': instance.category,
      'is_blocked': instance.isBlocked,
      'department': instance.department,
      'batch': instance.batch,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'total_followers': instance.totalFollowers,
      'total_following': instance.totalFollowing,
      'total_posts': instance.totalPosts,
    };

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$ChannelImpl',
      json,
      ($checkedConvert) {
        final val = _$ChannelImpl(
          id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
          title: $checkedConvert('title', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          totalFollowers: $checkedConvert(
              'total_followers', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {'totalFollowers': 'total_followers'},
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'total_followers': instance.totalFollowers,
    };

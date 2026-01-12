// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelPost _$ChannelPostFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ChannelPost',
      json,
      ($checkedConvert) {
        final val = ChannelPost(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          content: $checkedConvert('content', (v) => v as String?),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          deletedAt: $checkedConvert('deleted_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          channel: $checkedConvert(
              'channel',
              (v) => v == null
                  ? null
                  : Channel.fromJson(v as Map<String, dynamic>)),
          media: $checkedConvert(
              'media',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
                  .toList()),
          likeCount:
              $checkedConvert('totalLikes', (v) => (v as num?)?.toInt() ?? 0),
          commentCount: $checkedConvert(
              'totalComments', (v) => (v as num?)?.toInt() ?? 0),
          isLiked: $checkedConvert('is_liked', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'deletedAt': 'deleted_at',
        'likeCount': 'totalLikes',
        'commentCount': 'totalComments',
        'isLiked': 'is_liked'
      },
    );

Map<String, dynamic> _$ChannelPostToJson(ChannelPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'user': instance.user?.toJson(),
      'channel': instance.channel?.toJson(),
      'media': instance.media?.map((e) => e.toJson()).toList(),
      'totalLikes': instance.likeCount,
      'totalComments': instance.commentCount,
      'is_liked': instance.isLiked,
    };

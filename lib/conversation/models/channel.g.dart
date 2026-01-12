// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Channel',
      json,
      ($checkedConvert) {
        final val = Channel(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          avatar: $checkedConvert('profileImageUrl', (v) => v as String?),
          subscriberCount: $checkedConvert(
              'totalFollowers', (v) => (v as num?)?.toInt() ?? 0),
          isSubscribed:
              $checkedConvert('is_subscribed', (v) => v as bool? ?? false),
          isOfficial:
              $checkedConvert('is_official', (v) => v as bool? ?? false),
          field: $checkedConvert('field', (v) => v as String?),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          updatedAt: $checkedConvert('updated_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'avatar': 'profileImageUrl',
        'subscriberCount': 'totalFollowers',
        'isSubscribed': 'is_subscribed',
        'isOfficial': 'is_official',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at'
      },
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'profileImageUrl': instance.avatar,
      'totalFollowers': instance.subscriberCount,
      'is_subscribed': instance.isSubscribed,
      'is_official': instance.isOfficial,
      'field': instance.field,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

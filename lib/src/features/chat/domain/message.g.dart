// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      myUserId: json['myUserId'] as String,
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isMine: json['isMine'] as bool?,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'myUserId': instance.myUserId,
      'id': instance.id,
      'profileId': instance.profileId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'isMine': instance.isMine,
    };

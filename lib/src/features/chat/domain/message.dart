// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@unfreezed
class Message with _$Message {
  factory Message._internal({
    required String myUserId,
    required String id,
    required String profileId,
    required String content,
    required DateTime createdAt,
    bool? isMine,
  }) = _Message;

  factory Message({
    required String myUserId,
    required String id,
    required String profileId,
    required String content,
    required DateTime createdAt,
    bool? isMine,
  }) {
    return Message._internal(
      myUserId: myUserId,
      id: id,
      profileId: profileId,
      content: content,
      createdAt: createdAt,
      isMine: (profileId == myUserId),
    );
  }

  /// ID of the message
  // final String id;

  // /// ID of the user who posted the message
  // final String profileId;

  // /// Text content of the message
  // final String content;

  // /// Date and time when the message was created
  // final DateTime createdAt;

  // /// Whether the message is sent by the user or not.

  // Message.fromMap({
  //   required Map<String, dynamic> map,
  //   required String myUserId,
  // })  : id = map['id'],
  //       roomId = map['room_id'],
  //       profileId = map['profile_id'],
  //       content = map['content'],
  //       createdAt = DateTime.parse(map['created_at']),
  //       isMine = myUserId == map['profile_id'];

  factory Message.fromJson(Map<String, Object?> json) => _$MessageFromJson(json);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@unfreezed
class Message with _$Message {
  var myUserId;

  factory Message({
    required this.myUserId,
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    this.isMine,
  }) = _Message;

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String profileId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  /// Whether the message is sent by the user or not.
  late final bool? isMine;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  factory Message.toJson() => _$MessageToJson(this);
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'profile_id': profileId,
  //     'content': content,
  //     'created_at': createdAt.toIso8601String(),
  //     "isMine": profileId == myUserId ? true : false,
  //   };
  // }

  String toJson() => _$MessageToJson(this);
}

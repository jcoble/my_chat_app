// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
  }) = _Profile;

  /// User ID of the profile
  final String id;

  /// Username of the profile
  final String username;

  /// Date and time when the profile was created
  final DateTime createdAt;

  // Profile.fromMap(Map<String, dynamic> map)
  //     : id = map['id'],
  //       username = map['username'],
  //       createdAt = DateTime.parse(map['created_at']);

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'username': username,
  //     'createdAt': createdAt.millisecondsSinceEpoch,
  //   };
  // }

  factory Message.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  factory Message.toJson() => _$ProflleToJson(this);
}

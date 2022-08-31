// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  /// User ID of the profile
  final String id;

  /// Username of the profile
  final String username;

  /// Date and time when the profile was created
  final DateTime createdAt;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        createdAt = DateTime.parse(map['created_at']);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source) as Map<String, dynamic>);
}

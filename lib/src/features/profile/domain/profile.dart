// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  factory Profile({
    required String id,
    required String username,
    required DateTime createdAt,
  }) = _Profile;

  /// User ID of the profile
  // final String id;

  // /// Username of the profile
  // final String username;

  // /// Date and time when the profile was created
  // final DateTime createdAt;

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

  /// User ID of the profile
  @override
  final String id;

  /// Username of the profile
  @override
  final String username;

  /// Date and time when the profile was created
  @override
  final DateTime createdAt;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        createdAt = DateTime.parse(map['created_at']);

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}

// class Profile {
//   Profile({
//     required this.id,
//     required this.username,
//     required this.createdAt,
//   });

//   /// User ID of the profile
//   final String id;

//   /// Username of the profile
//   final String username;

//   /// Date and time when the profile was created
//   final DateTime createdAt;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'username': username,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//     };
//   }

//   Profile.fromMap(Map<String, dynamic> map)
//       : id = map['id'],
//         username = map['username'],
//         createdAt = DateTime.parse(map['created_at']);

//   Profile copyWith({
//     String? id,
//     String? name,
//     DateTime? createdAt,
//   }) {
//     return Profile(
//       id: id ?? this.id,
//       username: name ?? username,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

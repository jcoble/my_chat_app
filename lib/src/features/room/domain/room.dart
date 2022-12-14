import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat_app/src/features/messages/domain/message.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'room.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'room.g.dart';

@unfreezed
class Room with _$Room {
  factory Room({required String id, required DateTime createdAt, required String otherUserId, Message? lastMessage}) =
      _Room;

  /// ID of the room
  @override
  final String id;

  // /// Date and time when the room was created
  @override
  final DateTime createdAt;

  // /// ID of the user who the user is talking to
  @override
  final String otherUserId;

  // /// Latest message submitted in the room
  @override
  final Message? lastMessage;

  factory Room.fromJson(Map<String, Object?> json) => _$RoomFromJson(json);

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'createdAt': createdAt.millisecondsSinceEpoch,
  //   };
  // }

  /// Creates a room object from room_participants table
  Room.fromRoomParticipants(Map<String, dynamic> map)
      : id = map['room_id'],
        otherUserId = map['profile_id'],
        createdAt = DateTime.parse(map['created_at']),
        lastMessage = null;
}

// class Room {
//   Room({
//     required this.id,
//     required this.createdAt,
//     required this.otherUserId,
//     this.lastMessage,
//   });

//   /// ID of the room
//   final String id;

//   /// Date and time when the room was created
//   final DateTime createdAt;

//   /// ID of the user who the user is talking to
//   final String otherUserId;

//   /// Latest message submitted in the room
//   final Message? lastMessage;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//     };
//   }

//   /// Creates a room object from room_participants table
//   Room.fromRoomParticipants(Map<String, dynamic> map)
//       : id = map['room_id'],
//         otherUserId = map['profile_id'],
//         createdAt = DateTime.parse(map['created_at']),
//         lastMessage = null;

//   Room copyWith({
//     String? id,
//     DateTime? createdAt,
//     String? otherUserId,
//     Message? lastMessage,
//   }) {
//     return Room(
//       id: id ?? this.id,
//       createdAt: createdAt ?? this.createdAt,
//       otherUserId: otherUserId ?? this.otherUserId,
//       lastMessage: lastMessage ?? this.lastMessage,
//     );
//   }
// }



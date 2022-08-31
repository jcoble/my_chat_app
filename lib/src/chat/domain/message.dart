// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  var myUserId;

  Message({
    required this.myUserId,
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    this.isMine,
  });

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

  Message.fromMap(
    Map<String, dynamic> decode, {
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = myUserId == map['profile_id'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profileId': profileId,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isMine': isMine,
    };
  }

  // function to convert json to map
  // factory Message.fromJson(String source) =>
  // Message.fromMap(json.decode(source) as Map<String, dynamic>, map: json.decode(source) as Map<String, dynamic>, myUserId: profileId);
  factory Message.fromJson(Map<String, dynamic> map) => Message(
        myUserId: map['myUserId'],
        id: map['id'],
        profileId: map['profileId'],
        content: map['content'],
        createdAt: DateTime.parse(map['createdAt']),
        isMine: map['isMine'],
      );

  String toJson() => json.encode(toMap());

  Message copyWith({
    String? myUserId,
    String? id,
    String? profileId,
    String? content,
    DateTime? createdAt,
    bool? isMine,
  }) {
    return Message(
      myUserId: myUserId ?? this.myUserId,
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
    );
  }
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get myUserId => throw _privateConstructorUsedError;
  set myUserId(String value) => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  set profileId(String value) => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  set roomId(String value) => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  set content(String value) => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  set createdAt(DateTime value) => throw _privateConstructorUsedError;
  bool? get isMine => throw _privateConstructorUsedError;
  set isMine(bool? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) = _$MessageCopyWithImpl<$Res>;
  $Res call(
      {String myUserId, String id, String profileId, String roomId, String content, DateTime createdAt, bool? isMine});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res> implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  final Message _value;
  // ignore: unused_field
  final $Res Function(Message) _then;

  @override
  $Res call({
    Object? myUserId = freezed,
    Object? id = freezed,
    Object? profileId = freezed,
    Object? roomId = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? isMine = freezed,
  }) {
    return _then(_value.copyWith(
      myUserId: myUserId == freezed
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: profileId == freezed
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: roomId == freezed
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isMine: isMine == freezed
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$$_MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$_MessageCopyWith(_$_Message value, $Res Function(_$_Message) then) = __$$_MessageCopyWithImpl<$Res>;
  @override
  $Res call(
      {String myUserId, String id, String profileId, String roomId, String content, DateTime createdAt, bool? isMine});
}

/// @nodoc
class __$$_MessageCopyWithImpl<$Res> extends _$MessageCopyWithImpl<$Res> implements _$$_MessageCopyWith<$Res> {
  __$$_MessageCopyWithImpl(_$_Message _value, $Res Function(_$_Message) _then)
      : super(_value, (v) => _then(v as _$_Message));

  @override
  _$_Message get _value => super._value as _$_Message;

  @override
  $Res call({
    Object? myUserId = freezed,
    Object? id = freezed,
    Object? profileId = freezed,
    Object? roomId = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? isMine = freezed,
  }) {
    return _then(_$_Message(
      myUserId: myUserId == freezed
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: profileId == freezed
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: roomId == freezed
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isMine: isMine == freezed
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Message implements _Message {
  _$_Message(
      {required this.myUserId,
      required this.id,
      required this.profileId,
      required this.roomId,
      required this.content,
      required this.createdAt,
      this.isMine});

  factory _$_Message.fromJson(Map<String, dynamic> json) => _$$_MessageFromJson(json);

  @override
  String myUserId;
  @override
  String id;
  @override
  String profileId;
  @override
  String roomId;
  @override
  String content;
  @override
  DateTime createdAt;
  @override
  bool? isMine;

  @override
  String toString() {
    return 'Message._internal(myUserId: $myUserId, id: $id, profileId: $profileId, roomId: $roomId, content: $content, createdAt: $createdAt, isMine: $isMine)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_MessageCopyWith<_$_Message> get copyWith => __$$_MessageCopyWithImpl<_$_Message>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageToJson(
      this,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'room_id': roomId,
      'content': content,
    };
  }
}

abstract class _Message implements Message {
  factory _Message(
      {required String myUserId,
      required String id,
      required String profileId,
      required String roomId,
      required String content,
      required DateTime createdAt,
      bool? isMine}) = _$_Message;

  factory _Message.fromJson(Map<String, dynamic> json) = _$_Message.fromJson;

  @override
  String get myUserId;
  set myUserId(String value);
  @override
  String get id;
  set id(String value);
  @override
  String get profileId;
  set profileId(String value);
  @override
  String get roomId;
  set roomId(String value);
  @override
  String get content;
  set content(String value);
  @override
  DateTime get createdAt;
  set createdAt(DateTime value);
  @override
  bool? get isMine;
  set isMine(bool? value);
  @override
  @JsonKey(ignore: true)
  _$$_MessageCopyWith<_$_Message> get copyWith => throw _privateConstructorUsedError;
}

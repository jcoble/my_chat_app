// part of 'rooms_cubit.dart';

import 'package:flutter/material.dart';
import 'package:my_chat_app/src/features/profile/domain/profile.dart';
import 'package:my_chat_app/src/features/room/domain/room.dart';

@immutable
abstract class RoomState {}

class RoomsLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<Profile> newUsers;
  final List<Room> rooms;

  RoomsLoaded({
    required this.rooms,
    required this.newUsers,
  });
}

class RoomsEmpty extends RoomState {
  final List<Profile> newUsers;

  RoomsEmpty({required this.newUsers});
}

class RoomsError extends RoomState {
  final String message;

  RoomsError(this.message);
}

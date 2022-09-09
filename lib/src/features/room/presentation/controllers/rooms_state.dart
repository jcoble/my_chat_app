import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/messages/domain/message.dart';
import 'package:my_chat_app/src/features/messages/presentation/chat_page/messages_controller.dart';
import 'package:my_chat_app/src/features/profile/data/profile_repository.dart';
import 'package:my_chat_app/src/features/profile/domain/profile.dart';
import 'package:my_chat_app/src/features/room/domain/room.dart';
import 'package:my_chat_app/src/utils/constants.dart';

part 'rooms_cubit.dart';

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

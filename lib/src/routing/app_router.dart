import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_up/sign_up_page.dart';
import 'package:my_chat_app/src/features/chat/domain/message.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_page/chat_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_rooms/chat_room_list.dart';
import 'package:my_chat_app/src/features/user_management/presentation/account_page/account_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/profile_page/profile_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/settings_page/settings_page.dart';
import 'package:my_chat_app/src/routing/not_found_page.dart';
import 'package:flutter/material.dart';

enum AppRoute { chatRoomList, chatRoom, signOut, settings, profile, account, signIn, signUp }

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
});

import 'package:flutter/material.dart';
import 'package:my_chat_app/src/features/authentication/presentation/forgot_password/forgot_password.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_up/sign_up_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_page/chat_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_rooms/chat_list_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/account_page/account_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/profile_page/profile_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/settings_page/settings_page.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String home = '/';
  static const String signIn = 'signIn';
  static const String signUp = 'signUp';
  static const String rooms = 'rooms';
  static const String room = 'room/:id';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String account = 'account';
  static const String contact = 'contact';
  static const String privacyPolicy = 'privacy-policy';
  static const String termsOfService = 'terms-of-service';
  static const String notFound = 'not-found';
  static const String signOut = '/sign-out';

  static List<GoRoute> getRoutes() {
    return [
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, state) => RoomListPage(),
        routes: [
          // GoRoute(
          //   path: AppRoutes.home,
          //   name: AppRoutes.home,
          //   pageBuilder: (context, state) => MaterialPage(
          //     key: state.pageKey,
          //     fullscreenDialog: false,
          //     child: HomePage(),
          //   ),
          GoRoute(
            path: 'room/:id',
            name: AppRoutes.room,
            builder: (context, state) {
              final roomId = state.params['id']!;
              return ChatPage(
                roomId: roomId,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutes.settings,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: const SettingsPage(),
            ),
          ),
          GoRoute(
            path: 'profile',
            name: AppRoutes.profile,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: ProfilePage(),
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoutes.account,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: const AccountPage(),
            ),
          ),
          GoRoute(
            path: 'forgotPassword',
            name: AppRoutes.forgotPassword,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: ForgotPasswordPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoutes.signIn,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(path: '/signUp', name: AppRoutes.signUp, builder: (context, state) => SignUpPage()),
    ];
  }
}

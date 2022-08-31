import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/authentication/presentation/account_page/account_page.dart';
import 'package:my_chat_app/src/authentication/presentation/controllers/settings_page.dart';
import 'package:my_chat_app/src/chat/presentation/chat_pages/chat_page.dart';
import 'package:my_chat_app/src/chat/presentation/chat_rooms/chat_room_list.dart';
import 'package:my_chat_app/src/chat/presentation/profiles_pages/profiles_pages.dart';
import 'package:my_chat_app/src/routing/not_found_page.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/src/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/authentication/presentation/sign_up/sign_up_page.dart';

enum AppRoute { chatRoomList, chatRoom, signOut, settings, profile, account, signIn, signUp }

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        if (state.location != '/signIn' && state.location != '/signUp') {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.chatRoomList.name,
        builder: (context, state) => const ChatRoomListPage(),
        routes: [
          GoRoute(
            path: 'room/:id',
            name: AppRoute.chatRoom.name,
            builder: (context, state) {
              final roomId = state.params['id']!;
              return ChatPage(
                roomId: roomId,
                chatId: '',
                messages: null,
                otherUserId: '',
              );
            },
            routes: [
              GoRoute(
                path: 'account',
                name: AppRoute.account.name,
                pageBuilder: (context, state) {
                  final productId = state.params['id']!;
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: const Text('Account'),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const ProfilePage(),
            ),
            routes: [
              GoRoute(
                path: 'account',
                name: AppRoute.account.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: ValueKey(state.location),
                  fullscreenDialog: true,
                  child: const AccountPage(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const SettingsPage(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const SignInPage(),
            ),
          ),
          GoRoute(
            path: 'signUp',
            name: AppRoute.signUp.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const SignUpPage(
                isRegistering: true,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

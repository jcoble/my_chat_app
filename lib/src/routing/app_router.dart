import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_up/sign_up_page.dart';
import 'package:my_chat_app/src/features/chat/domain/message.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_page/chat_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_rooms/home_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/account_page/account_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/profile_page/profile_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/settings_page/settings_page.dart';
import 'package:my_chat_app/src/routing/not_found_page.dart';
import 'package:flutter/material.dart';

enum AppRoute { home, room, signOut, settings, profile, account, signIn, signUp }

// final goRouterProvider = Provider<GoRouter>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
// });

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        // go home if logged in and somehow get to signIn or SignUp Uri's
        if (state.location == '/signIn' || state.location == '/signUp') {
          return '/';
        }
      } else {
        // not logged in so redirect to signIn
        return '/signIn';
        // if (state.location != '/signIn' && state.location != '/signUp') {
        //   return '/signIn';
        // }
      }
      return state.location;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'room/:id',
            name: AppRoute.room.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: ChatPage(roomId: state.params['id']!),
            ),
          ),
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: ProfilePage(),
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              key: ValueKey(state.location),
              fullscreenDialog: true,
              child: const AccountPage(),
            ),
          ),
          GoRoute(
            path: 'settings',
            name: AppRoute.settings.name,
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
              fullscreenDialog: false,
              child: const SignInPage(),
            ),
          ),
          GoRoute(
            path: 'signUp',
            name: AppRoute.signUp.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: const SignUpPage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

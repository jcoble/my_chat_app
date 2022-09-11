import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/features/authentication/presentation/forgot_password/forgot_password.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_up/sign_up_page.dart';
import 'package:my_chat_app/src/features/authentication/presentation/splash/splash_page.dart';
import 'package:my_chat_app/src/features/messages/presentation/chat_page/chat_page.dart';
import 'package:my_chat_app/src/features/room/presentation/rooms_page/rooms_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/account_page/account_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/profile_page/profile_page.dart';
import 'package:my_chat_app/src/features/user_management/presentation/settings_page/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String home = 'home';
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
  static const String signOut = 'signOut';

  // static const String splash = 'splash';
//   static List<GoRoute> getRoutes({required ProviderRef<GoRouter> ref}) {
//     return [
//       GoRoute(
//         path: '/signIn',
//         name: AppRoutes.signIn,
//         builder: (context, state) => const SignInPage(),
//       ),
//       GoRoute(
//         path: '/splash',
//         name: AppRoutes.splash,
//         builder: (context, state) => const SplashPage(),
//       ),
//       GoRoute(
//         path: '/signUp',
//         name: AppRoutes.signUp,
//         builder: (context, state) => const SignUpPage(),
//       ),
//       GoRoute(
//         path: '/',
//         name: AppRoutes.home,
//         builder: (context, state) => const RoomsPage(),
//         routes: [
//           // GoRoute(
//           //   path: 'rooms',
//           //   name: AppRoutes.rooms,
//           //   builder: (context, state) => const RoomsPage(),
//           // ),
//           GoRoute(
//             path: 'room/:id',
//             name: AppRoutes.room,
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               fullscreenDialog: false,
//               child: ChatPage(
//                 roomId: state.params['id']!,
//               ),
//             ),
//           ),
//           GoRoute(
//             path: "settings",
//             name: AppRoutes.settings,
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               fullscreenDialog: false,
//               child: const SettingsPage(),
//             ),
//           ),
//           GoRoute(
//             path: 'profile',
//             name: AppRoutes.profile,
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               fullscreenDialog: false,
//               child: const ProfilePage(),
//             ),
//           ),
//           GoRoute(
//             path: 'account',
//             name: AppRoutes.account,
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               fullscreenDialog: false,
//               child: const AccountPage(),
//             ),
//           ),
//           GoRoute(
//             path: 'forgotPassword',
//             name: AppRoutes.forgotPassword,
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               fullscreenDialog: false,
//               child: ForgotPasswordPage(),
//             ),
//           ),
//         ],
//       ),
//     ];
//   }
// }
  static List<GoRoute> getRoutes({required ProviderRef<GoRouter> ref}) {
    return [
      GoRoute(path: '/splash', name: AppRoutes.splash, builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, state) => RoomsPage(),
        routes: [
          GoRoute(
            path: 'rooms',
            name: AppRoutes.rooms,
            builder: (context, state) => const RoomsPage(),
          ),
          GoRoute(
            path: 'room/:id',
            name: AppRoutes.room,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: ChatPage(
                roomId: state.params['id']!,
              ),
            ),
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
      // GoRoute(path: '/splash', name: AppRoutes.splash, builder: (context, state) => const Preload()),
      GoRoute(path: '/signOut', name: AppRoutes.signOut, builder: (context, state) => SignInPage()),
    ];
  }
}

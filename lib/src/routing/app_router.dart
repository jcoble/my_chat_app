import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/routing/not_found_page.dart';
import 'package:my_chat_app/src/routing/routes.dart';

// enum AppRoute { splash, home, room, signOut, settings, profile, account, signIn, signUp, forgotPassword }

// final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue>((ref) {
//   final authRepository = ref.watch(authSubscriptionProvider);
//   authRepository.listenAuthChangeEvent();
//   return AuthController(
//     authRepository: authRepository,
//     ref: ref,
//   );
// });

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (state) {
      // final authRepo = ref.read(authRepositoryProvider);
      // final state = authRepo.auth.read(routerProvider);
      // if the user is not logged in, they need to login
      // final loggedIn = authRepo.currentUser != null;
      // if (!loggedIn && state.subloc != '/sign-in' && state.subloc != '/sign-up') {
      //   return '/sign-in';
      // }
      // return null;
      final authRepo = ref.read(authRepositoryProvider);
      // final state = authRepo.auth.read(routerProvider);
      // if the user is not logged in, they need to login
      final loggedIn = authRepo.currentUser != null;
      final loggingIn = state.subloc == '/signIn' || state.subloc == '/signUp';

      if (!loggedIn) return loggingIn ? null : '/signIn';

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn && loggedIn) return '/';
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges()),
    routes: AppRoutes.getRoutes(),
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

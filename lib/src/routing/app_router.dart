import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/routing/not_found_page.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SupabaseFlutter;

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
    // redirect: (state) {
    //   final authRepo = ref.read(authRepositoryProvider);
    //   // final state = ref.read(authRepo);
    //   // if the user is not logged in, they need to login
    //   // final loggedIn = authRepo.currentUser != null;
    //   // if (!loggedIn && state.subloc != '/sign-in' && state.subloc != '/sign-up') {
    //   //   return '/sign-in';
    //   // }
    //   // return null;
    //   // final authRepo = ref.read(authRepositoryProvider);
    //   // final state = authRepo.auth.read(routerProvider);
    //   // if the user is not logged in, they need to login
    //   final loggedIn = authRepo.currentUser != null;
    //   final loggingIn = state.subloc == '/signIn' || state.subloc == '/signUp' || state.subloc == '/splash';

    //   if (!loggedIn) return loggingIn ? null : '/signIn';

    //   if (loggedIn && state.subloc == "/") return null;
    //   // if the user is logged in but still on the login page, send them to
    //   // the home page
    //   if (loggingIn && loggedIn) return '/';

    //   if (loggedIn && state.subloc == "") return '/';
    //   return null;
    // },
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges()),
    routes: AppRoutes.getRoutes(ref: ref),
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (state) {
      final authRepo = ref.read(authRepositoryProvider);

      // if the user is not logged in, they need to login
      final loggedIn = authRepo.currentUser != null;
      final loggingIn = state.subloc == '/signIn';
      final subloc = state.subloc;
      final fromp2 = subloc == '/' ? '' : '?from=$subloc';
      if (!loggedIn) return loggingIn ? null : '/signIn$fromp2';

      // if the user is logged in but the repository is not loaded, they need to
      // wait while it's loaded
      final loaded = SupabaseFlutter.Supabase.instance.client.auth != null;
      final loading = state.subloc == '/splash';
      final from = state.queryParams['from'];
      final fromp1 = from == null ? '' : '?from=$from';
      if (!loaded) return loading ? null : '/splash$fromp1';

      //   // if the user is logged in and the repository is loaded, send them where
      //   // they were going before (or home if they weren't going anywhere)
      if (loggingIn || loading) return from ?? '/';

      // no need to redirect at all
      return null;
    },
  );
});

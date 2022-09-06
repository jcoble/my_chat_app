import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'package:my_chat_app/src/app.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';

// import 'package:my_chat_app/src/authentication/presentation/splash/splash_page.dart';
import 'package:my_chat_app/src/utils/constants.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    SupabaseAuthUi().initSupabase(Environment.supabaseURL, Environment.supabaseAnonKey);
    // turn off the # in the URLs on the web
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
    // * Entry point of the app
    runApp(ProviderScope(child: MyApp()));

    // * This code will present some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}

// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final goRouter = ref.watch(goRouterProvider);
//     return MaterialApp.router(
//       routerDelegate: goRouter.routerDelegate,
//       routeInformationParser: goRouter.routeInformationParser,
//       debugShowCheckedModeBanner: false,
//       restorationScopeId: 'app',
//       title: 'Chat App',
//       theme: appTheme,
//       home: const SplashPage(),
//     );
//   }
// }

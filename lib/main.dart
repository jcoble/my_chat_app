import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/app.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_chat_app/src/authentication/presentation/splash/splash_page.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // await Supabase.initialize(
  //     url: Environment.SupabaseURL,
  //     anonKey: Environment.SupabaseAnonKey,
  //     authCallbackUrlHostname: 'login-callback', // optional
  //     debug: true // optional
  //     );
  await SupabaseAuthUi().initSupabase(Environment.supabaseURL, Environment.supabaseAnonKey);
  // turn off the # in the URLs on the web
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  // * Entry point of the app
  runApp(const ProviderScope(child: MyApp()));
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

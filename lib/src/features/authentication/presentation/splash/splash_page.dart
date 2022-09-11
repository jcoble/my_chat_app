import 'package:flutter/material.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/room/presentation/rooms_page/rooms_page.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    try {
      final session = await SupabaseAuth.instance.initialSession;
      // if (session == null) {
      //   //  Navigator.of(context)
      //   //     .push(AppRoutes.signIn, (_) => false);

      //   Navigator.of(context).push<void>(
      //     MaterialPageRoute<void>(
      //       builder: (BuildContext context) => const SignInPage(),
      //     ),
      //   );
      //   // Navigator.of(context).push<void>(
      //   //   MaterialPageRoute<void>(
      //   //     builder: (BuildContext context) => const RoomsPage(),
      //   //   ),
      //   // );
      //   // context.goNamed(AppRoutes.signIn);
      // } else {
      //   // context.pushReplacementNamed('/chatRoomList');
      //   // Navigator.of(context).pushReplacementNamed(AppRoute.home.name);
      //   // context.go(AppRoutes.rooms);

      //   Navigator.of(context).push<void>(
      //     MaterialPageRoute<void>(
      //       builder: (BuildContext context) => const RoomsPage(),
      //     ),
      //   );
      // }
    } catch (error) {
      print(error);
      context.goNamed(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Page to redirect users to the appropriate page depending on the initial auth state
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);

//   @override
//   SplashPageState createState() => SplashPageState();
// }

// class SplashPageState extends SupabaseAuthState<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: preloader);
//   }

//   @override
//   void onAuthenticated(Session session) {
//     Navigator.of(context).pushAndRemoveUntil(ChatPage.route(), (_) => false);
//   }

//   @override
//   void onUnauthenticated() {
//     Navigator.of(context).pushAndRemoveUntil(RegisterPage.route(), (_) => false);
//   }

//   @override
//   void onErrorAuthenticating(String message) {}

//   @override
//   void onPasswordRecovery(Session session) {}
// }

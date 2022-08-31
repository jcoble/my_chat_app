import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Preload extends StatefulWidget {
  const Preload({Key? key}) : super(key: key);

  @override
  State<Preload> createState() => _PreloadState();
}

class _PreloadState extends State<Preload> {
  @override
  void initState() async {
    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    try {
      final session = await SupabaseAuth.instance.initialSession;
      if (session == null) {
        Navigator.of(context).pushReplacementNamed('/signIn');
      } else {
        // context.pushReplacementNamed('/chatRoomList');
        Navigator.of(context).pushReplacementNamed(AppRoute.chatRoomList.name);
      }
    } catch (error) {
      Navigator.of(context).pushReplacementNamed('/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

/// Page to redirect users to the appropriate page depending on the initial auth state
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);

//   @override
//   SplashPageState createState() => SplashPageState();
// }

// class SplashPageState extends AuthState<SplashPage> {
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

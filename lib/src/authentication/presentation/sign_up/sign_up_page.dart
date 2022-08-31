import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/chat/presentation/home_app_bar/messages_icon.dart';
import 'package:my_chat_app/src/chat/presentation/home_app_bar/more_menu_button.dart';
import 'package:my_chat_app/src/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/chat/presentation/chat_pages/chat_page.dart';
import 'package:my_chat_app/src/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/utils/breakpoint.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key, required this.isRegistering}) : super(key: key);

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => SignUpPage(isRegistering: isRegistering),
    );
  }

  final bool isRegistering;

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final bool _isLoading = false;

  // final _formKey = GlobalKey<FormState>();

  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _usernameController = TextEditingController();

  // Future<void> _signUp() async {
  //   final isValid = _formKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   final email = _emailController.text;
  //   final password = _passwordController.text;
  //   final username = _usernameController.text;
  //   final res = await supabase.auth.signUp(email, password, userMetadata: {'username': username});
  //   final error = res.error;
  //   if (error != null) {
  //     context.showErrorSnackBar(message: error.message);
  //     return;
  //   }
  //   Navigator.of(context).pushAndRemoveUntil(ChatPage.route(), (route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);
    final user = authRepo.currentUser;
    // final screenWidth = MediaQuery.of(context).size.width;
    // ignore: prefer_const_constructors
    return Scaffold(
      body: SupaEmailAuth(authAction: AuthAction.signUp, redirectUrl: '/signIn'),
      //  TextButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(AppRoute.signIn.name);
      //   },
      //   child: Text('I have an account already.'.hardcoded),
      // ),
    );
  }
}

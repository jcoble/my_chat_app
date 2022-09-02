// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/features/authentication/presentation/sign_in/sign_in_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/chat_page/chat_page.dart';
import 'package:my_chat_app/src/features/chat/presentation/home_app_bar/messages_icon.dart';
import 'package:my_chat_app/src/features/chat/presentation/home_app_bar/more_menu_button.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/utils/breakpoint.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';

class SignUpPage extends ConsumerStatefulWidget {
  SignUpPage({
    required this.isRegistering,
  }) : super(key: key);
  
  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => SignUpPage(isRegistering: isRegistering),
    );
  }

  final bool isRegistering;

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();

  SignUpPage copyWith({
    bool? isRegistering,
  }) {
    return SignUpPage(
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isRegistering': isRegistering,
    };
  }

  factory SignUpPage.fromMap(Map<String, dynamic> map) {
    return SignUpPage(
      isRegistering: map['isRegistering'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpPage.fromJson(String source) => SignUpPage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SignUpPage(isRegistering: $isRegistering)';

  @override
  bool operator ==(covariant SignUpPage other) {
    if (identical(this, other)) return true;
  
    return 
      other.isRegistering == isRegistering;
  }

  @override
  int get hashCode => isRegistering.hashCode;
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHardcoded. ),
        actions: <Widget>[
          if (Breakpoint.isLargeScreen(context))
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => MoreMenuButton(
                    onSignIn: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRouter.signIn);
                    },
                  ),
                );
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading)
              const CircularProgressIndicator()
            else
               Text(StringHardcoded.signUp),
            const SizedBox(height: 16),
            if (!_isLoading)
              ElevatedButton(
                child: Text(StringHardcoded.signUp),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.chat);
                },
              ),
          ],
        ),
      ),
    );
  // timestamp with time zone default timezone('utc'::text, now()) not null


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

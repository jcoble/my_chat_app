import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'.hardcoded)),
      body: Container(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SupaEmailAuth(
              authAction: AuthAction.signIn,
              redirectUrl: '/',
            ),
            // Social Login Buttons
            const SupaSocialsAuth(
              socialProviders: [
                SocialProviders.google,
                SocialProviders.github,
              ],
              colored: true,
            ),
            Column(
              children: [
                TextButton(
                  child: const Text(
                    'Forgot Password? Click here',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => context.goNamed(AppRoutes.forgotPassword),
                ),
                TextButton(
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => context.goNamed(AppRoutes.signUp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class SignIn extends ConsumerStatefulWidget {
//   const SignIn({Key? key}) : super(key: key);

//   @override
//   ConsumerState<SignIn> createState() => _SignInState();
// }

// class _SignInState extends ConsumerState<SignIn> {
//   @override
//   Widget build(BuildContext context) {
//     final authRepo = ref.watch(authRepositoryProvider);
//     final user = authRepo.currentUser;
//     final screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth < Breakpoint.tablet) {
//       return AppBar(
//         title: Text('Chat App'.hardcoded),
//         actions: [
//           const MessagesIcon(),
//           MoreMenuButton(user: user),
//         ],
//       );
//     } else {
//       return const Scaffold(
//         // appBar: appBar,
//         body: SupaEmailAuth(
//           authAction: AuthAction.signIn,
//           redirectUrl: '/',
//         ),
//         // TextButton(
//         //   child: const Text(
//         //     'Forgot Password? Click here',
//         //     style: TextStyle(fontWeight: FontWeight.bold),
//         //   ),
//         //   onPressed: () => Navigator.pushNamed(context, '/forgot_password');
//         // ),
//         // TextButton(
//         //   child: const Text(
//         //     'Don\'t have an account? Sign Up',
//         //     style: TextStyle(fontWeight: FontWeight.bold),
//         //   ),
//         //   onPressed: () => Navigator.pushNamed(context, '/signUp'),
//         // ),
//         // const Divider(),
//         // optionText,
//         // spacer,
//         // signInBtn(context, Icons.email, 'Sign in with Magic Link', () {
//         //   Navigator.popAndPushNamed(context, '/magic_link');
//         // }),
//         // spacer,
//         // signInBtn(context, Icons.phone, 'Sign in with Phone', () {
//         //   Navigator.popAndPushNamed(context, '/phone_sign_in');
//         // }),
//       );
//     }
//   }
// }

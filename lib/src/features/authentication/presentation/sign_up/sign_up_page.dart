import 'package:flutter/material.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'.hardcoded)),
      body: Container(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SupaEmailAuth(
              authAction: AuthAction.signUp,
              redirectUrl: '/',
            ),
            spacer,
            const SupaSocialsAuth(
              colored: true,
              socialProviders: [
                SocialProviders.github,
                SocialProviders.google,
              ],
            ),
            Column(
              children: [
                TextButton(
                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => context.goNamed(AppRoutes.signIn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class SignUp extends ConsumerStatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   ConsumerState<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends ConsumerState<SignUp> {
//   @override
//   Widget build(BuildContext context) {
//     final authRepo = ref.watch(authRepositoryProvider);
//     final user = authRepo.currentUser;
//     final screenWidth = MediaQuery.of(context).size.width;
//     // if (screenWidth < Breakpoint.tablet) {
//     //   return AppBar(
//     //     title: Text('Chat App'.hardcoded),
//     //     actions: [
//     //       const MessagesIcon(),
//     //       MoreMenuButton(user: user),
//     //     ],
//     //   );
//     // } else {
//     return const Scaffold(
//       // appBar: appBar,
//       body: SupaEmailAuth(
//         authAction: AuthAction.signUp,
//         redirectUrl: '/',
//       ),
//       // TextButton(
//       //   child: const Text(
//       //     'Forgot Password? Click here',
//       //     style: TextStyle(fontWeight: FontWeight.bold),
//       //   ),
//       //   onPressed: () => Navigator.pushNamed(context, '/forgot_password');
//       // ),
//       // TextButton(
//       //   child: const Text(
//       //     'Don\'t have an account? Sign Up',
//       //     style: TextStyle(fontWeight: FontWeight.bold),
//       //   ),
//       //   onPressed: () => Navigator.pushNamed(context, '/signUp'),
//       // ),
//       // const Divider(),
//       // optionText,
//       // spacer,
//       // signInBtn(context, Icons.email, 'Sign in with Magic Link', () {
//       //   Navigator.popAndPushNamed(context, '/magic_link');
//       // }),
//       // spacer,
//       // signInBtn(context, Icons.phone, 'Sign in with Phone', () {
//       //   Navigator.popAndPushNamed(context, '/phone_sign_in');
//       // }),
//     );
//   }
//   // }
// }

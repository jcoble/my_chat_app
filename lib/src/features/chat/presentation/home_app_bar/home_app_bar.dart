import 'package:my_chat_app/src/components/action_text_button.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:my_chat_app/src/features/chat/presentation/home_app_bar/messages_icon.dart';
import 'package:my_chat_app/src/features/chat/presentation/home_app_bar/more_menu_button.dart';

import 'package:flutter/material.dart';
import 'package:my_chat_app/src/components/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:my_chat_app/src/utils/async_value_ui.dart';
import 'package:my_chat_app/src/utils/breakpoint.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';

// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
// [ProductScreen].
// It shows the following actions, depending on the application state:
// - [ShoppingCartIcon]
// - Orders button
// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    ref.listen<AsyncValue>(authControllerProvider, (_, state) => state.showAlertDialogOnError(context));
    final state = ref.watch(authControllerProvider);
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: Text('Messages'.hardcoded),
        actions: [
          MessagesIcon(),
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: Text('Messages'.hardcoded),
        actions: [
          MessagesIcon(),
          if (user != null) ...[
            // if (state.hasValue) ...[
            //   ActionTextButton(
            //     key: MoreMenuButton.signOutKey,
            //     text: 'Sign Out'.hardcoded,
            //     onPressed: () => context.pushNamed(AppRoutes.signOut),
            //   ),
            // ],
            ActionTextButton(
              key: MoreMenuButton.settingsKey,
              text: 'Settings'.hardcoded,
              onPressed: () => context.pushNamed(AppRoutes.settings),
            ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.profileKey,
              text: 'Profile'.hardcoded,
              onPressed: () => context.pushNamed(AppRoutes.profile),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

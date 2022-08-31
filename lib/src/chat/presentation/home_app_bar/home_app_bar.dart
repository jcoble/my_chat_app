import 'package:my_chat_app/src/authentication/data/auth_repository.dart';
import 'package:my_chat_app/src/chat/presentation/home_app_bar/messages_icon.dart';
import 'package:my_chat_app/src/chat/presentation/home_app_bar/more_menu_button.dart';
import 'package:my_chat_app/src/components/action_text_button.dart';
import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/utils/breakpoint.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';

import 'package:flutter/material.dart';
import 'package:my_chat_app/src/components/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
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
          const MessagesIcon(),
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: Text('Messages'.hardcoded),
        actions: [
          const MessagesIcon(),
          if (user != null) ...[
            ActionTextButton(
              key: MoreMenuButton.signOutKey,
              text: 'Sign Out'.hardcoded,
              onPressed: () => context.pushNamed(AppRoute.signOut.name),
            ),
            ActionTextButton(
              key: MoreMenuButton.settingsKey,
              text: 'Settings'.hardcoded,
              onPressed: () => context.pushNamed(AppRoute.settings.name),
            ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.profileKey,
              text: 'Profile'.hardcoded,
              onPressed: () => context.pushNamed(AppRoute.profile.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

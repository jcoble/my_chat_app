import 'package:my_chat_app/src/routing/app_router.dart';
import 'package:my_chat_app/src/routing/routes.dart';
import 'package:my_chat_app/src/utils/string_hardcoded.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'rooms_state.dart';

enum PopupMenuOption {
  signOut,
  settings,
  profile,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({Key? key, this.user}) : super(key: key);
  final User? user;

  // * Keys for testing using find.byKey()
  static const signOutKey = Key('menuSignOut');
  static const settingsKey = Key('menuSettings');
  static const profileKey = Key('menuProfile');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: signOutKey,
                  value: PopupMenuOption.signOut,
                  child: Text('Sign Out'.hardcoded),
                ),
                PopupMenuItem(
                  key: settingsKey,
                  value: PopupMenuOption.settings,
                  child: Text('Settings'.hardcoded),
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: profileKey,
                  value: PopupMenuOption.profile,
                  child: Text('Profile'.hardcoded),
                ),
              ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signOut:
            context.replaceNamed(AppRoutes.signOut);
            break;
          case PopupMenuOption.settings:
            context.replaceNamed(AppRoutes.settings);
            break;
          case PopupMenuOption.profile:
            context.replaceNamed(AppRoutes.profile);
            break;
        }
      },
    );
  }
}

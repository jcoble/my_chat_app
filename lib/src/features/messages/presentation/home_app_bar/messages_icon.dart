import 'package:my_chat_app/src/utils/constants.dart';
import 'package:flutter/material.dart';

/// Shopping cart icon with items count badge
class MessagesIcon extends StatelessWidget {
  const MessagesIcon({Key? key}) : super(key: key);

  // * Keys for testing using find.byKey()
  static const messagesIconKey = Key('messages-cart-icon');

  @override
  Widget build(BuildContext context) {
    var unreadMessagesCount;
    return Positioned(
      top: Sizes.p4,
      right: Sizes.p4,
      child: UnreadMessagesIconBadge(itemsCount: unreadMessagesCount),
    );
  }
}
// * Keys for testing using find.byKey()
//  const MessagesIconKey = Key('messages-cart-icon');

/// Icon badge showing the items count
class UnreadMessagesIconBadge extends StatelessWidget {
  const UnreadMessagesIconBadge({Key? key, required this.itemsCount}) : super(key: key);
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.p16,
      height: Sizes.p16,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          // color: Theme.of(appTheme).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$itemsCount',
          textAlign: TextAlign.center,
          // * Force textScaleFactor to 1.0 irrespective of the device's
          // * textScaleFactor. This is to prevent the text from growing bigger
          // * than the available space.
          textScaleFactor: 1.0,
          style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerWidget {
  ChatPage({Key? key, required this.roomId}) : super(key: key);
  final String roomId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatPage'),
      ),
      body: const Center(
        child: Text('ChatPage'),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:my_chat_app/src/components/user_avatar.dart';
// import 'package:my_chat_app/src/features/authentication/domain/profile.dart';
// import 'package:timeago/timeago.dart';

// // Page to chat with someone.
// ///
// /// Displays chat bubbles as a ListView and TextField to enter new chat.
// class ChatPage extends StatelessWidget {
//   const ChatPage({Key? key}) : super(key: key);

//   // static Route<void> route(String roomId) {
//   //   final messagesProvider = MessagesProvider();
//   //   return MaterialPageRoute(
//   //     builder: (context) => BlocProvider<MessagesCubit>(
//   //       create: (context) => MessagesCubit(messagesProvider: messagesProvider)..setMessagesListener(roomId),
//   //       child: const ChatPage(),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: BlocConsumer<MessagesCubit, MessagesState>(
//         listener: (context, state) {
//           if (state is MessagesError) {
//             context.showErrorSnackBar(message: state.message);
//           }
//         },
//         builder: (context, state) {
//           if (state is MessagesInitial) {
//             return preloader;
//           } else if (state is MessagesLoaded) {
//             final messages = state.messages;
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     reverse: true,
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       return _ChatBubble(message: message);
//                     },
//                   ),
//                 ),
//                 const _MessageBar(),
//               ],
//             );
//           } else if (state is MessagesEmpty) {
//             return Column(
//               children: const [
//                 Expanded(
//                   child: Center(
//                     child: Text('Start your conversation now :)'),
//                   ),
//                 ),
//                 _MessageBar(),
//               ],
//             );
//           } else if (state is MessagesError) {
//             return Center(child: Text(state.message));
//           }
//           throw UnimplementedError();
//         },
//       ),
//     );
//   }
// }

// /// Set of widget that contains TextField and Button to submit message
// class _MessageBar extends StatefulWidget {
//   const _MessageBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<_MessageBar> createState() => _MessageBarState();
// }

// class _MessageBarState extends State<_MessageBar> {
//   late final TextEditingController _textController;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Theme.of(context).cardColor,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 keyboardType: TextInputType.text,
//                 maxLines: null,
//                 autofocus: true,
//                 controller: _textController,
//                 decoration: const InputDecoration(
//                   hintText: 'Type a message',
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   contentPadding: EdgeInsets.all(8),
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () => _submitMessage(),
//               child: const Text('Send'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     _textController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }

//   void _submitMessage() async {
//     final text = _textController.text;
//     if (text.isEmpty) {
//       return;
//     }
//     BlocProvider.of<MessagesCubit>(context).sendMessage(text);
//     _textController.clear();
//   }
// }

// class _ChatBubble extends StatelessWidget {
//   const _ChatBubble({
//     Key? key,
//     required this.message,
//   }) : super(key: key);

//   final Message message;

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> chatContents = [
//       if (!message.isMine) UserAvatar(userId: message.profileId),
//       const SizedBox(width: 12),
//       Flexible(
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 8,
//             horizontal: 12,
//           ),
//           decoration: BoxDecoration(
//             color: message.isMine ? Colors.black : Theme.of(context).primaryColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(message.content),
//         ),
//       ),
//       const SizedBox(width: 12),
//       Text(format(message.createdAt, locale: 'en_short')),
//       const SizedBox(width: 60),
//     ];
//     if (message.isMine) {
//       chatContents = chatContents.reversed.toList();
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
//       child: Row(
//         mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: chatContents,
//       ),
//     );
//   }
// }


// // import 'dart:html';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:my_chat_app/src/features/chat/domain/message.dart';

// // class ChatPage extends ConsumerWidget {
// //   const ChatPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final chatController = ref.watch(chatControllerProvider);
// //     final messages = ref.watch(chatControllerProvider.state);
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Chat'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final message = messages[index];
// //                 return ListTile(
// //                   title: Text(message.text),
// //                 );
// //               },
// //             ),
// //           ),
// //           TextField(
// //             onSubmitted: (text) {
// //               chatController.sendMessage(Message(text: text));
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

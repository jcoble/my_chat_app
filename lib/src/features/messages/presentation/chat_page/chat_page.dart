import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/cubits/messages/messages_cubit.dart';
import 'package:my_chat_app/src/components/user_avatar.dart';
import 'package:my_chat_app/src/features/messages/data/messages_repository.dart';
import 'package:my_chat_app/src/features/messages/domain/message.dart';
import 'package:my_chat_app/src/features/messages/presentation/chat_page/messages_controller.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:timeago/timeago.dart';

class ChatPage extends ConsumerWidget {
  final String roomId;
  const ChatPage({Key? key, required this.roomId}) : super(key: key);

  static Route<void> route(String roomId, WidgetRef ref) {
    final messagesController = MessagesController(messagesRepository: ref.watch(messagesRepositoryProvider));
    return MaterialPageRoute(
      builder: (context) => BlocProvider<MessagesCubit>(
        create: (context) =>
            MessagesCubit(messagesRepository: messagesController.messagesRepository)..setMessagesListener(roomId),
        child: ChatPage(roomId: roomId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: BlocConsumer<MessagesCubit, MessagesState>(
        listener: (context, state) {
          if (state is MessagesError) {
            context.showErrorSnackBar(message: state.message);
          }
        },
        builder: (context, state) {
          if (state is MessagesInitial) {
            return preloader;
          } else if (state is MessagesLoaded) {
            final messages = state.messages;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _ChatBubble(message: message);
                    },
                  ),
                ),
                const _MessageBar(),
              ],
            );
          } else if (state is MessagesEmpty) {
            return Column(
              children: const [
                Expanded(
                  child: Center(
                    child: Text('Start your conversation now :)'),
                  ),
                ),
                _MessageBar(),
              ],
            );
          } else if (state is MessagesError) {
            return Center(child: Text(state.message));
          }
          throw UnimplementedError();
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: null,
                autofocus: true,
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            TextButton(
              onPressed: () => _submitMessage(),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    BlocProvider.of<MessagesCubit>(context).sendMessage(text);
    _textController.clear();
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.isMine ?? false;
    List<Widget> chatContents = [
      if (!isMyMessage) UserAvatar(userId: message.profileId),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isMyMessage ? Colors.black : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (isMyMessage) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

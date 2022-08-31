// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage(this.profileCache, {
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

    late final Stream<List<Message>> messagesStream = supabase
      .from('chats:room_id=eq.{roomId}')
      .stream(['id'])
      .order('created_at')
      .execute()
      .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
      // final res = await supabase.from('profiles').select().match({'id': profileId}).single();
      final profile = Profile.fromMap(data);
      profileCache[profileId] = profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
t';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
tter_riverpod.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
entication/domain/profile.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
/data/chat_repository.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:my_chat_app/src/authentication/domain/profile.dart';
import 'package:my_chat_app/src/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends ConsumerWidget {
  final String chatId;
  final String otherUserId;
  final List<Message> messages;
  final String roomId;
  final Map<String, Profile> profileCache;
  ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    required this.roomId
  }) : super(key: key);

   Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chatId: chatId, messages: messages, otherUserId: otherUserId, roomId: roomId,
      ),
    );
  }


    final myUserId = supabase.auth.currentUser!.id;
     
     
     
     
     
     
   if(myUserId == otherUserId)  {
    return Text('You can not chat with yourself');
   }

   

  Future<void> _loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

late final Stream<List<Message>> messagesStream = supabase
   .from('chats:room_id=eq.{roomId}')
   .stream(['id'])
   .order('created_at')
   .execute()
   .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: {}, myUserId: '')).toList());
  final res = await supabase.from('profiles').select().match({'id': profileId}).single();
  profileCache[profileId] = profile;

 

    final data = res.data;
    if (data != null) {
      final profile = Profile.fromMap(data);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return _ChatBubble(
                              message: message,
                              profile: profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends ConsumerStatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final myUserId = supabase.auth.currentUser!.id;
    ref.listen(chatControllerProvider, (prev, next) {
      if (prev != next) {
        _textController.text = next.toString();
      }
    });
    final chatController = ref.watch(chatControllerProvider.notifier);

    return Material(
      color: Colors.grey[200],
      child: SafeArea(
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
                onPressed: () => chatController.sendMessage(_textController.text!),
                child: const Text('Send'),
              ),
            ],
          ),
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
    final myUserId = supabase.auth.currentUser!.id;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    final controller = ref.watch(chatControllerProvider.notifier);
    controller.sendMessage({});
    // final error = res.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null ? preloader : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

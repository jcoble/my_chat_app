import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({Key? key, required this.roomId}) : super(key: key);
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

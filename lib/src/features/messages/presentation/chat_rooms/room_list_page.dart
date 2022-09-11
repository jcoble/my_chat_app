import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomListPage extends ConsumerWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Chat Room List Page(Home Page)'),
      ),
    );
  }

  route(String home) {}
}

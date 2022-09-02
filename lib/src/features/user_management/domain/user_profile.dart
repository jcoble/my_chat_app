import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValuePage extends ConsumerWidget {
  AsyncValuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Value'),
      ),
      body: const Center(
        child: Text('Async Value'),
      ),
    );
  }
}

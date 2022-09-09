import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/messages/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:rxdart/subjects.dart';

class MessagesRepository {
  final Map<String, StreamSubscription<List<Message>>> _messageSubscriptions = {};
  final Map<String, StreamController<List<Message>>> _messageControllers = {};

  String? _myUserId;

  Stream<List<Message>> subscribe(String roomId) async* {
    _myUserId ??= supabase.auth.currentUser!.id;

    _messageControllers[roomId] ??= BehaviorSubject();

    _messageSubscriptions[roomId] ??= supabase
        .from('messages:room_id=eq.$roomId')
        .stream(['id'])
        .order('created_at')
        .map<List<Message>>(
          (data) => data
              .map<Message>(
                (row) => Message.fromMap(
                  map: row,
                  myUserId: _myUserId!,
                ),
              )
              .toList(),
        )
        .listen((messages) {
          _messageControllers[roomId]!.add(messages);
        });

    yield* _messageControllers[roomId]!.stream;
  }

  void clear() {
    for (final listener in _messageSubscriptions.values) {
      listener.cancel();
    }
    for (final controller in _messageControllers.values) {
      controller.close();
    }
  }
}

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepository();
});

final messagesStreamProvider = StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return messagesRepository.subscribe(roomId);
});

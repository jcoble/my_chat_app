import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

import 'package:flutter/material.dart';

class ChatController extends StateNotifier<AsyncValue> {
  ChatController({required this.chatRepository}) : super(const AsyncValue.data(null));
  final ChatRepository chatRepository;

  Future<bool> sendMessage(Message message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => chatRepository.sendMessage(message));
    return state.error == null;
  }

  // get stream of messages from ChatRepository
  Stream<List<Message>> get messagesStream => chatRepository.getMyMessagesStream();
}

final chatControllerProvider = StateNotifierProvider.autoDispose<ChatController, ChatRepository>(
  (ref) => ChatController(chatRepository: ref.read(chatRepositoryProvider)),
);

class ChatRepository {
  Future<bool> sendMessage(Message message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => chatRepository.sendMessage(message));
    return state.error == null;
  }

  // stream of messages from the server (ordered by created_at)
  Stream<List<Message>> getMyMessagesStream() {
    final myUserId = supabase.auth.currentUser!.id;
    return supabase
        .from('messages')
        .stream(['chats:room_id=eq.{myUserId}'])
        .order('created_at')
        .execute()
        .map((maps) => maps.map((map) => Message.fromMap({myUserId: myUserId}, map: map, myUserId: myUserId)).toList());
  }

  Future<bool> sendMessage(Message message) async {
    final res = await supabase.from('messages').insert(message.toMap());
    return res.error == null;
  }
}

final chatRepositoryProvider = Provider((ref) => ChatRepository());

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/chat/data/chat_repository.dart';
import 'package:my_chat_app/src/features/chat/domain/message.dart';
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

final chatControllerProvider = StateNotifierProvider.autoDispose<ChatController, AsyncValue>(
  (ref) => ChatController(chatRepository: ref.read(chatRepositoryProvider)),
);

final messagesStreamProvider = StreamProvider.autoDispose<List<Message>>((ref) {
  final chatController = ref.watch(chatControllerProvider.notifier);
  return chatController.messagesStream;
});

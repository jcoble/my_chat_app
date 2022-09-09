import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/messages/data/messages_repository.dart';
import 'package:my_chat_app/src/features/messages/domain/message.dart';
import 'package:my_chat_app/src/features/messages/domain/messages_state.dart';
import 'package:my_chat_app/src/utils/constants.dart';

class MessagesController extends StateNotifier<MessagesState> {
  MessagesController({required this.messagesRepository}) : super(MessagesState(value: const AsyncValue.loading()));

  final MessagesRepository messagesRepository;
  StreamSubscription<List<Message>>? _messagesSubscription;
  List<Message> _messages = [];

  late final String _roomId;
  late final String _myUserId;

  void setMessagesListener(String roomId) {
    _roomId = roomId;

    _myUserId = supabase.auth.currentUser!.id;
    state = state.copyWith(value: const AsyncValue.loading());
    _messagesSubscription = messagesRepository.subscribe(roomId).listen((messages) {
      _messages = messages;
      if (_messages.isEmpty) {
        state = state.copyWith(value: const AsyncValue.data(null));
      } else {
        state = state.copyWith(value: AsyncData(_messages));
      }
    });
  }

  Future<void> sendMessage(String text) async {
    /// Add message to present to the user right away
    final message = Message(
        myUserId: '',
        id: 'new',
        roomId: _roomId,
        profileId: _myUserId,
        content: text,
        createdAt: DateTime.now(),
        isMine: true);
    _messages.insert(0, message);
    state = state.copyWith(value: AsyncData(_messages));
    final result = await supabase.from('messages').insert(message.toMap());
    final error = result.error;
    if (error != null) {
      /// Remove message from present to the user
      /// if there was an error
      _messages.removeWhere((message) => message.id == 'new');
      state = state.copyWith(value: AsyncData(_messages));
      state = state.copyWith(value: const AsyncData(null));
      throw Exception(error.message);
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}

final messagesControllerProvider = StateNotifierProvider.autoDispose<MessagesController, MessagesState>((ref) {
  final messagesRepository = ref.watch(messagesRepositoryProvider);
  return MessagesController(messagesRepository: messagesRepository);
});

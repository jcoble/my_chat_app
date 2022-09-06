import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.

class ChatRepository {
  Future<Message> sendMessage(Message message) async {
    return await supabase.from("messages").insert(message.toJson());
  }

  // stream of messages from the server (ordered by created_at)
  // only from user's that have sent messages to the current user.
  Stream<List<Message>> getMyMessagesStream() {
    final myUserId = supabase.auth.currentUser!.id;
    return supabase.from('messages').stream(['messages:profile_id=eq.$myUserId']).order('created_at').map((maps) => maps
        .map(
          (map) => Message.fromMap(map: map, myUserId: myUserId),
        )
        .toList());
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatRepo = ChatRepository();
  return chatRepo;
});

// final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });

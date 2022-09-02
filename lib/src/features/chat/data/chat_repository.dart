import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/chat/domain/message.dart';
import 'package:my_chat_app/src/utils/constants.dart';

import 'package:flutter/material.dart';

// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<AsyncValue> {
  var chatRepository;

  late final Stream<List<Message>>  async {};
  @override
  Future<bool> sendMessage(Message message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard((message) => chatRepository.sendMessage(message));
    return state.error == null;
  }

  // get stream of messages from ChatRepository
  Stream<List<Message>> get messagesStream => chatRepository.getMyMessagesStream();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final chatControllerProvider = StateNotifierProvider.autoDispose<ChatController, ChatRepository>(
  (ref) => ChatController(chatRepository: ref.read(chatRepositoryProvider)),
);

class ChatRepository {
  // Future<bool> sendMessage(Message message) async {
  //   return await supabase.from("messages").insert(message.toJson());
  //   if (x.?.error != null) {
  //     return x.toMap();
  //   }
  //   return true;
  // }
  // Future<bool> sendMessage(Message message) async {
  //   await supabase.
  //   return state.error == null;
  // }

  // stream of messages from the server (ordered by created_at)
  // only from user's that have sent messages to the current user.
  Stream<List<Message>> getMyMessagesStream() {
    final myUserId = supabase.auth.currentUser!.id;
    return supabase
        .from('messages')
        .stream(['messages:profile_id=eq.$myUserId'])
        .order('created_at')
        .execute()
        .map((maps) => maps
            .map(
              (map) => Message.fromMap({myUserId: myUserId}, map: map, myUserId: myUserId),
            )
            .toList());
  }

  Future<bool> sendMessage(Message message) async {
    final res = await supabase.from('messages').insert(message.toMap());
    return res.error == null;
  }
}

final chatRepositoryProvider = Provider((ref) => ChatRepository());

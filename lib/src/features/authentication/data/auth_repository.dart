import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  // final _authState = InMemoryStore<User?>(Supabase.instance.client.auth.currentUser);
  // Stream<User?> authStateChanges() => _authState.stream;
  final _subject = BehaviorSubject<User?>.seeded(Supabase.instance.client.auth.currentUser);
  Stream<User?> get stream => _subject.stream;
  Stream<User?> authStateChanges() => _subject.stream;

  User? get currentUser => _subject.value;

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _subject.value = null;
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // GotrueSubscription? listenAuthChangeEvent() {
  //   return Supabase.instance.client.auth.onAuthStateChange((event, session) => _subject.value = session?.user);
  // }

  dispose() => _subject.close();
}

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

// final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

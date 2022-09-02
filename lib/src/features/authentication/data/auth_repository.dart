import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/authentication/domain/profile.dart';
import 'package:my_chat_app/src/utils/constants.dart';
import 'package:my_chat_app/src/utils/in_memory_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final _authState = InMemoryStore<User?>(Supabase.instance.client.auth.currentUser);
  Stream<User?> authStateChanges() => _authState.stream;
  User? get currentUser => _authState.value;

  Future<void> signOut() async {
    _authState.value = null;
  }
  
  dispose() {}
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

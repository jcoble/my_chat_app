import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/authentication/domain/profile.dart';
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

  void dispose() => _authState.close();

  Future<Profile> getProfile() async {
    final response = await supabase.from('profiles').select().single();
    return Profile.fromMap(response);
  }

  Future<void> updateProfile(Profile profile) async {
    await supabase.from('profiles').update(profile.toMap());
  }
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

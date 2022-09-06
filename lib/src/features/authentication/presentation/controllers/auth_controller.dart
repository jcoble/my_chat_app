// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;
  AuthController({required this.authRepository}) : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }

  // GotrueSubscription? listenAuthChangeEvent() {
  //   return authRepository.listenAuthChangeEvent();
  // }
}

// final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
//   return AuthRepository();
// });

// final authSubscriptionProvider = StateNotifierProvider.autoDispose<AuthController, GotrueSubscription?>((ref) {
//   final authRepository = ref.watch(authControllerProvider.notifier);
//   return authRepository.listenAuthChangeEvent();
// });

final authControllerProvider = StateNotifierProvider.autoDispose<AuthController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

// final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });

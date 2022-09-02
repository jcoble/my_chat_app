import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/authentication/data/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue> {
  AuthController({required this.authRepository}) : super(const AsyncValue.data(null));
  final AuthRepository authRepository;

  Future<bool> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return state.error == null;
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AuthController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
  );
});

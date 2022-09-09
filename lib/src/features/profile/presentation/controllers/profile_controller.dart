import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/profile/data/profile_repository.dart';
import 'package:my_chat_app/src/features/profile/domain/profile_state.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final Ref ref;
  final ProfileRepository profileRepository;
  ProfileController(this.ref, this.profileRepository) : super(ProfileState(value: const AsyncValue.loading()));

  Future<void> getProfile(String userId) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => profileRepository.getProfile(userId));
    state = state.copyWith(value: value);
  }
}

final profileControllerProvider = StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(ref, profileRepository);
});

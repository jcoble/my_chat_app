import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat_app/src/features/profile/domain/profile.dart';
import 'package:my_chat_app/src/utils/constants.dart';

class ProfileRepository {
  final Ref ref;
  ProfileRepository(this.ref);

  final Map<String, Profile?> _profiles = {};

  Future<void> getProfile(String userId) async {
    if (_profiles[userId] != null) {
      return;
    }

    try {
      final res = await supabase.from('profiles').select().match({'id': userId}).single();
      final data = res as Map<String, dynamic>;
      _profiles[userId] = Profile.fromMap(data);
    } on Exception catch (e) {
      // TODO
    }
    //

    // if (data == null) {
    //   return;
    // }
  }
}

final profileRepositoryProvider = Provider.autoDispose<ProfileRepository>((ref) {
  return ProfileRepository(ref);
});

// final profileProvider = Provider.autoDispose.family<Profile?, String>((ref, userId) {
//   final profileRepository = ref.watch(profileRepositoryProvider);
//   profileRepository.getProfile(userId);
//   return profileRepository._profiles[userId];
// });

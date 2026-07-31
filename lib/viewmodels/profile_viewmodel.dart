import 'package:planit/core/database/database_providers.dart';
import 'package:planit/models/user_profile.dart';
import 'package:planit/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

/// Holds the local user profile (name / email / avatar). `null` means the user
/// has not completed profile setup yet.
@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late final ProfileRepository _profileRepository;

  @override
  Future<UserProfile?> build() async {
    _profileRepository = ProfileRepository(ref.watch(appDatabaseProvider));
    return _profileRepository.getProfile();
  }

  Future<void> save(UserProfile profile) async {
    await _profileRepository.saveProfile(profile);
    state = AsyncValue.data(profile);
  }
}

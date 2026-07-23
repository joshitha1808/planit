import 'package:planit/core/database/database_providers.dart';
import 'package:planit/repository/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_viewmodel.g.dart';

/// Exposes whether onboarding has already been completed and lets the UI
/// mark it as done. Persisted locally through drift.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  late final SettingsRepository _settingsRepository;

  @override
  Future<bool> build() async {
    _settingsRepository = SettingsRepository(ref.watch(appDatabaseProvider));
    return _settingsRepository.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    await _settingsRepository.completeOnboarding();
    state = const AsyncValue.data(true);
  }
}

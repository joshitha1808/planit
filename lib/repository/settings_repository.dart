import 'package:planit/core/database/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  static const _onboardingKey = 'onboarding_completed';

  Future<bool> isOnboardingCompleted() async {
    final row =
        await (_db.select(_db.appSettings)
              ..where((t) => t.key.equals(_onboardingKey)))
            .getSingleOrNull();
    return row?.value == 'true';
  }

  Future<void> completeOnboarding() async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _onboardingKey, value: 'true'),
        );
  }
}

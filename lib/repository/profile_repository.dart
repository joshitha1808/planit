import 'package:planit/core/database/app_database.dart';
import 'package:planit/models/user_profile.dart';

class ProfileRepository {
  final AppDatabase _db;

  ProfileRepository(this._db);

  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  static const _avatarKey = 'profile_avatar';

  Future<String?> _read(String key) async {
    final row =
        await (_db.select(_db.appSettings)..where((t) => t.key.equals(key)))
            .getSingleOrNull();
    return row?.value;
  }

  Future<void> _write(String key, String value) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  /// Returns the saved profile, or null if the user has not set one up yet.
  Future<UserProfile?> getProfile() async {
    final name = await _read(_nameKey);
    if (name == null || name.isEmpty) return null;
    return UserProfile(
      name: name,
      email: await _read(_emailKey) ?? '',
      avatar: await _read(_avatarKey) ?? '',
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _write(_nameKey, profile.name);
    await _write(_emailKey, profile.email);
    await _write(_avatarKey, profile.avatar);
  }
}

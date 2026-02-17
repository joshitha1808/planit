import 'package:planit/repository/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late SupabaseClient _supabaseClient;

  @override
  AsyncValue<User>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _supabaseClient = Supabase.instance.client;

    return null;
  }

  bool isUserLoggedIn() {
    return _supabaseClient.auth.currentSession != null;
  }

  Future<void> signinUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signin(
      email: email,
      password: password,
    );

    res.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }
}

import 'package:fpdart/fpdart.dart';
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
    // or _supabaseClient.auth.currentSession!=null(instead if if-else condition we can do like this also)
    if (_supabaseClient.auth.currentSession == null) {
      return false; // here user is null(means user is not present) so we r returning false
    } else {
      return true; // here user is present
    }
  }

  Future<UserResponse> get user => _supabaseClient.auth.getUser();

  // sign in
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

  //SIGN UP
  Future<void> signupUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signup(
      userName: userName,
      email: email,
      password: password,
    );

    res.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  //Logout
  Future<void> logoutUser() async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.logout();

    res.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (succecc) => state = null,
    );
  }
}

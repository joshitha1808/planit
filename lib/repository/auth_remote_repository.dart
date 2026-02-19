import 'package:fpdart/fpdart.dart';
import 'package:planit/core/error/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository(Supabase.instance.client);
}

class AuthRemoteRepository {
  final SupabaseClient supabaseClient;

  AuthRemoteRepository(this.supabaseClient);

  Future<Either<Failure, User>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        return left(Failure('Login failed. No user found.'));
      }

      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //signup
  Future<Either<Failure, User>> signup({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        data: {"username": userName},
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        return left(Failure('Signup failed. Unable to create user.'));
      }

      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //Logout
  Future<Either<Failure, void>> logout() async {
    try {
      await supabaseClient.auth.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

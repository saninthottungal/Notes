import 'package:firebase2/Services/Auth/AuthUser.dart';

abstract class AuthProvider {
  AuthUser? getCurrentUser();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<void> firebaseInitialize();
}

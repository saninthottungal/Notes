import 'package:firebase2/Services/Auth/AuthProvider.dart';
import 'package:firebase2/Services/Auth/AuthUser.dart';

class AuthService implements AuthProvider {
  AuthProvider provider;

  AuthService(this.provider);

  @override
  AuthUser? getCurrentUser() {
    return provider.getCurrentUser();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    return provider.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return provider.signOut();
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) {
    return provider.signUp(email: email, password: password);
  }
}

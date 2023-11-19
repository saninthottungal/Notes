import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final User _user;
  bool get isEmailVerified => _user.emailVerified;

  void refreshUser() {
    _user.reload();
  }

  AuthUser(this._user);

  factory AuthUser.fromFirebase(User user) => AuthUser(user);
}

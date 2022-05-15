import 'package:login_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {}
}

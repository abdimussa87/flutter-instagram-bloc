import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User> get user;
  Future<auth.User> signupWithEmailAndPassword({
    String username,
    String email,
    String password,
  });
  Future<auth.User> loginWithEmailAndPassword({
    String email,
    String password,
  });

  Future<void> logout();
}

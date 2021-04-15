import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:instagram_bloc/config/paths.dart';
import 'package:instagram_bloc/models/models.dart';
import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore firebaseFirestore,
    auth.FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User> get user => _firebaseAuth.userChanges();
  @override
  Future<auth.User> signupWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      await _firebaseFirestore.collection(Paths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message,
      );
    } on PlatformException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message,
      );
    }
  }

  @override
  Future<auth.User> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message,
      );
    } on PlatformException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message,
      );
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

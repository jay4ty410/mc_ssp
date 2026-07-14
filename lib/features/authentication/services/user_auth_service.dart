import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserAuthService {
  UserAuthService({FirebaseAuth? auth, UserRepository? userRepository})
    : _auth = auth ?? FirebaseAuth.instance,
      _userRepository = userRepository ?? UserRepository();

  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  Future<String?> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      developer.log(
        'SignUp started for email=$email',
        name: 'UserAuthService.signUp',
      );

      developer.log(
        'Creating auth account for email=$email',
        name: 'UserAuthService.signUp',
      );
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        developer.log(
          'Auth account created but user object is null',
          name: 'UserAuthService.signUp',
        );
        return 'Registration failed. Please try again.';
      }

      developer.log(
        'Auth account created: uid=${user.uid}, email=${user.email}',
        name: 'UserAuthService.signUp',
      );

      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? email.trim(),
        displayName: displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      developer.log(
        'Creating Firestore user document for uid=${user.uid}',
        name: 'UserAuthService.signUp',
      );
      await _userRepository.createUser(newUser);
      developer.log(
        'Successfully created Firestore user document for uid=${user.uid}',
        name: 'UserAuthService.signUp',
      );
      return null;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during signUp: ${e.code} - ${e.message}',
        name: 'UserAuthService.signUp',
        error: e,
      );
      return _mapAuthError(e);
    } catch (e) {
      developer.log(
        'Unexpected error during signUp: $e',
        name: 'UserAuthService.signUp',
        error: e,
      );
      return 'Unexpected error during sign up: $e';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      developer.log(
        'SignIn started for email=$email',
        name: 'UserAuthService.signIn',
      );

      developer.log(
        'Authenticating with Firebase Auth for email=$email',
        name: 'UserAuthService.signIn',
      );
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      developer.log(
        'Successfully authenticated: uid=${_auth.currentUser?.uid}',
        name: 'UserAuthService.signIn',
      );
      return null;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during signIn: ${e.code} - ${e.message}',
        name: 'UserAuthService.signIn',
        error: e,
      );
      return _mapAuthError(e);
    } catch (e) {
      developer.log(
        'Unexpected error during signIn: $e',
        name: 'UserAuthService.signIn',
        error: e,
      );
      return 'Unexpected error during sign in: $e';
    }
  }

  Future<String?> signOut() async {
    try {
      developer.log(
        'SignOut started for uid=${_auth.currentUser?.uid}',
        name: 'UserAuthService.signOut',
      );

      await _auth.signOut();

      developer.log('Successfully signed out', name: 'UserAuthService.signOut');
      return null;
    } catch (e) {
      developer.log(
        'Unexpected error during signOut: $e',
        name: 'UserAuthService.signOut',
        error: e,
      );
      return 'Unexpected error during sign out: $e';
    }
  }

  User? get currentUser => _auth.currentUser;

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password sign in is currently disabled.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account was found for that email.';
      case 'wrong-password':
        return 'The password you entered is incorrect.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

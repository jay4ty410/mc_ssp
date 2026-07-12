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
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return 'Registration failed. Please try again.';
      }

      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? email.trim(),
        displayName: displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.createUser(newUser);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Unexpected error during sign up: $e';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Unexpected error during sign in: $e';
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
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

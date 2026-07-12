import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../repositories/user_repository.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance,
      _userRepository = UserRepository(firestore: firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;

  static String getUserFacingErrorMessage(Object error) {
    final code = _normalizeErrorCode(_extractErrorCode(error));
    final message = _extractErrorMessage(error);

    switch (code) {
      case 'configuration-not-found':
      case 'app-not-authorized':
      case 'invalid-app-credential':
      case 'firebase-auth/configuration-not-found':
        return 'Firebase authentication is not configured correctly for this app. Please verify the Firebase project settings and try again.';
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
      case 'network-request-failed':
        return 'Please check your internet connection and try again.';
      case 'permission-denied':
        return 'Firestore rejected the request. Please verify the Firestore security rules allow the authenticated user to read and write their own data.';
      default:
        return message ?? 'Authentication failed.';
    }
  }

  static String _extractErrorCode(Object error) {
    if (error is FirebaseAuthException) {
      return error.code;
    }
    if (error is FirebaseException) {
      return error.code;
    }
    if (error is PlatformException) {
      return error.code;
    }
    if (error is String) {
      return error;
    }
    return '';
  }

  static String _normalizeErrorCode(String code) {
    final normalized = code.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '-',
    );
    return normalized
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  static String? _extractErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      return error.message;
    }
    if (error is FirebaseException) {
      return error.message;
    }
    if (error is PlatformException) {
      return error.message;
    }
    return null;
  }

  /// Register user and create the Firestore profile.
  Future<void> registerAndSendVerification({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'registration-failed',
          message: 'Registration failed',
        );
      }

      try {
        await user.updateDisplayName(name);
        await user.reload();
      } catch (_) {}

      final now = DateTime.now();
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: name,
        isVerified: false,
        createdAt: now,
        updatedAt: now,
      );

      await _userRepository.createUser(userModel);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: getUserFacingErrorMessage(e),
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: _extractErrorCode(e).isNotEmpty
            ? _extractErrorCode(e)
            : 'registration-failed',
        message: getUserFacingErrorMessage(e),
      );
    }
  }

  /// Sign in and allow access immediately after authentication.
  Future<User?> signInAndCheckVerified({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      var user = cred.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user returned',
        );
      }

      await user.reload();
      user = _auth.currentUser;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user returned',
        );
      }

      final uid = user.uid;
      await _userRepository.updateUser(uid, {
        'isVerified': true,
        'lastLogin': Timestamp.fromDate(DateTime.now()),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: getUserFacingErrorMessage(e),
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: _extractErrorCode(e).isNotEmpty
            ? _extractErrorCode(e)
            : 'authentication-failed',
        message: getUserFacingErrorMessage(e),
      );
    }
  }
}

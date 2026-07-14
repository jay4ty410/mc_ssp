import 'dart:developer' as developer;

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
      case 'firestore-error':
        return 'A database error occurred. Your account may not have been fully set up. Please try logging in again, or contact support if the problem persists.';
      case 'not-found':
        return 'Your user profile could not be found. This may be a temporary issue - please try again.';
      default:
        return message ?? 'Authentication failed. Please try again.';
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
      developer.log(
        'Registration started for email=$email',
        name: 'AuthService.registerAndSendVerification',
      );

      developer.log(
        'Creating auth account for email=$email',
        name: 'AuthService.registerAndSendVerification',
      );
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        developer.log(
          'Auth account created but user object is null for email=$email',
          name: 'AuthService.registerAndSendVerification',
        );
        throw FirebaseAuthException(
          code: 'registration-failed',
          message: 'Registration failed - user object unavailable',
        );
      }

      developer.log(
        'Auth account successfully created: uid=${user.uid}, email=${user.email}',
        name: 'AuthService.registerAndSendVerification',
      );

      try {
        developer.log(
          'Updating Firebase display name for uid=${user.uid}',
          name: 'AuthService.registerAndSendVerification',
        );
        await user.updateDisplayName(name);
        await user.reload();
        developer.log(
          'Successfully updated display name for uid=${user.uid}',
          name: 'AuthService.registerAndSendVerification',
        );
      } catch (e) {
        developer.log(
          'Warning: Failed to update display name for uid=${user.uid}: $e',
          name: 'AuthService.registerAndSendVerification',
        );
      }

      final now = DateTime.now();
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: name,
        isVerified: false,
        createdAt: now,
        updatedAt: now,
      );

      developer.log(
        'Creating Firestore user document for uid=${user.uid}',
        name: 'AuthService.registerAndSendVerification',
      );
      await _userRepository.createUser(userModel);
      developer.log(
        'Successfully created Firestore user document for uid=${user.uid}',
        name: 'AuthService.registerAndSendVerification',
      );
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during registration: ${e.code} - ${e.message}',
        name: 'AuthService.registerAndSendVerification',
        error: e,
      );
      throw FirebaseAuthException(
        code: e.code,
        message: getUserFacingErrorMessage(e),
      );
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during registration: ${e.code} - ${e.message}',
        name: 'AuthService.registerAndSendVerification',
        error: e,
      );
      throw FirebaseAuthException(
        code: 'firestore-error',
        message: getUserFacingErrorMessage(e),
      );
    } catch (e) {
      developer.log(
        'Unexpected error during registration: $e',
        name: 'AuthService.registerAndSendVerification',
        error: e,
      );
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
      developer.log(
        'Login started for email=$email',
        name: 'AuthService.signInAndCheckVerified',
      );

      developer.log(
        'Authenticating with Firebase Auth for email=$email',
        name: 'AuthService.signInAndCheckVerified',
      );
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      var user = cred.user;
      if (user == null) {
        developer.log(
          'Auth sign-in succeeded but user object is null',
          name: 'AuthService.signInAndCheckVerified',
        );
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user returned after sign-in',
        );
      }

      developer.log(
        'Auth sign-in successful: uid=${user.uid}, email=${user.email}',
        name: 'AuthService.signInAndCheckVerified',
      );

      await user.reload();
      user = _auth.currentUser;

      if (user == null) {
        developer.log(
          'After reload, current user is null',
          name: 'AuthService.signInAndCheckVerified',
        );
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user returned after reload',
        );
      }

      final uid = user.uid;
      developer.log(
        'Updating user verification status for uid=$uid',
        name: 'AuthService.signInAndCheckVerified',
      );
      await _userRepository.updateUser(uid, {
        'isVerified': true,
        'lastLogin': Timestamp.fromDate(DateTime.now()),
      });

      developer.log(
        'Successfully completed login for uid=$uid',
        name: 'AuthService.signInAndCheckVerified',
      );
      return user;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during login: ${e.code} - ${e.message}',
        name: 'AuthService.signInAndCheckVerified',
        error: e,
      );
      throw FirebaseAuthException(
        code: e.code,
        message: getUserFacingErrorMessage(e),
      );
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during login: ${e.code} - ${e.message}',
        name: 'AuthService.signInAndCheckVerified',
        error: e,
      );
      throw FirebaseAuthException(
        code: 'firestore-error',
        message: getUserFacingErrorMessage(e),
      );
    } catch (e) {
      developer.log(
        'Unexpected error during login: $e',
        name: 'AuthService.signInAndCheckVerified',
        error: e,
      );
      throw FirebaseAuthException(
        code: _extractErrorCode(e).isNotEmpty
            ? _extractErrorCode(e)
            : 'authentication-failed',
        message: getUserFacingErrorMessage(e),
      );
    }
  }
}

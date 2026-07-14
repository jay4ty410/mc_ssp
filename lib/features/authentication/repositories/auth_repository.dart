import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/features/authentication/repositories/user_repository.dart';
import 'package:mc_ssp/features/authentication/models/user_model.dart';

/// Simple AuthRepository that wraps `firebase_auth` and creates a Firestore
/// `users` document for newly registered users using the existing
/// `UserRepository`/`UserModel`.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _userRepository = UserRepository(firestore: firestore);

  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    developer.log(
      'AuthRepository.signIn started for email=$email',
      name: 'AuthRepository.signIn',
    );
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      developer.log(
        'Successfully signed in: uid=${cred.user?.uid}',
        name: 'AuthRepository.signIn',
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during signIn: ${e.code} - ${e.message}',
        name: 'AuthRepository.signIn',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during signIn: $e',
        name: 'AuthRepository.signIn',
        error: e,
      );
      rethrow;
    }
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    developer.log(
      'AuthRepository.register started for email=$email, name=$name',
      name: 'AuthRepository.register',
    );
    try {
      developer.log(
        'Creating auth account for email=$email',
        name: 'AuthRepository.register',
      );
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        developer.log(
          'Auth account created: uid=${user.uid}',
          name: 'AuthRepository.register',
        );

        // Update display name on the Firebase user profile
        try {
          developer.log(
            'Updating display name for uid=${user.uid}',
            name: 'AuthRepository.register',
          );
          await user.updateDisplayName(name);
          await user.reload();
          developer.log(
            'Successfully updated display name for uid=${user.uid}',
            name: 'AuthRepository.register',
          );
        } catch (e) {
          developer.log(
            'Warning: Failed to update display name: $e',
            name: 'AuthRepository.register',
          );
        }

        // Create Firestore user document using the shared UserModel
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        developer.log(
          'Creating Firestore user document for uid=${user.uid}',
          name: 'AuthRepository.register',
        );
        await _userRepository.createUser(userModel);
        developer.log(
          'Successfully created Firestore user document for uid=${user.uid}',
          name: 'AuthRepository.register',
        );
      } else {
        developer.log(
          'Auth account created but user object is null',
          name: 'AuthRepository.register',
        );
      }

      return cred;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during register: ${e.code} - ${e.message}',
        name: 'AuthRepository.register',
        error: e,
      );
      rethrow;
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during register: ${e.code} - ${e.message}',
        name: 'AuthRepository.register',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during register: $e',
        name: 'AuthRepository.register',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    developer.log(
      'Sending password reset email to: $email',
      name: 'AuthRepository.sendPasswordReset',
    );
    try {
      await _auth.sendPasswordResetEmail(email: email);
      developer.log(
        'Password reset email sent successfully to: $email',
        name: 'AuthRepository.sendPasswordReset',
      );
    } catch (e) {
      developer.log(
        'Error sending password reset email: $e',
        name: 'AuthRepository.sendPasswordReset',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    developer.log('Signing out user', name: 'AuthRepository.signOut');
    try {
      await _auth.signOut();
      developer.log('Successfully signed out', name: 'AuthRepository.signOut');
    } catch (e) {
      developer.log(
        'Error during sign out: $e',
        name: 'AuthRepository.signOut',
        error: e,
      );
      rethrow;
    }
  }
}

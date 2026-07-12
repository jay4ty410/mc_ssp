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
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      // Update display name on the Firebase user profile
      try {
        await user.updateDisplayName(name);
        await user.reload();
      } catch (_) {}

      // Create Firestore user document using the shared UserModel
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.createUser(userModel);
    }

    return cred;
  }

  Future<void> sendPasswordReset({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

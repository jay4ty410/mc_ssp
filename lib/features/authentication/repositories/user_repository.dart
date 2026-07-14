import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/settings_model.dart';
import '../models/statistics_model.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> createUser(UserModel user) async {
    developer.log(
      'Starting createUser for uid=${user.uid}, email=${user.email}',
      name: 'UserRepository.createUser',
    );

    final userDoc = _usersCollection.doc(user.uid);
    final batch = _firestore.batch();

    developer.log(
      'Setting main user document with data: uid=${user.uid}',
      name: 'UserRepository.createUser',
    );
    batch.set(userDoc, user.toMap());

    developer.log(
      'Setting profile subcollection for uid=${user.uid}',
      name: 'UserRepository.createUser',
    );
    batch.set(userDoc.collection('profile').doc('profile'), {
      'displayName': user.displayName,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'role': user.role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    developer.log(
      'Setting settings subcollection for uid=${user.uid}',
      name: 'UserRepository.createUser',
    );
    batch.set(
      userDoc.collection('settings').doc('settings'),
      SettingsModel().toMap(),
      SetOptions(merge: true),
    );

    developer.log(
      'Setting statistics subcollection for uid=${user.uid}',
      name: 'UserRepository.createUser',
    );
    batch.set(
      userDoc.collection('statistics').doc('statistics'),
      StatisticsModel().toMap(),
      SetOptions(merge: true),
    );

    try {
      developer.log(
        'Committing batch write for uid=${user.uid}',
        name: 'UserRepository.createUser',
      );
      await FirestoreService.runSafely(
        path: 'users/${user.uid}',
        operation: 'createUser',
        action: () => batch.commit(),
      );
      developer.log(
        'Successfully created user document and subcollections for uid=${user.uid}',
        name: 'UserRepository.createUser',
      );
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during batch commit for uid=${user.uid}: ${e.code} - ${e.message}',
        name: 'UserRepository.createUser',
        error: e,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unexpected error during batch commit for uid=${user.uid}: $e',
        name: 'UserRepository.createUser',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    developer.log(
      'Starting getUser for uid=$uid',
      name: 'UserRepository.getUser',
    );

    try {
      final snapshot = await FirestoreService.runSafely(
        path: 'users/$uid',
        operation: 'getUser',
        action: () => _usersCollection.doc(uid).get(),
      );

      if (!snapshot.exists) {
        developer.log(
          'User document does not exist for uid=$uid - creating new user document',
          name: 'UserRepository.getUser',
        );
        return null;
      }

      developer.log(
        'Successfully retrieved user document for uid=$uid',
        name: 'UserRepository.getUser',
      );
      return UserModel.fromMap((snapshot.data() ?? {}) as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during getUser for uid=$uid: ${e.code} - ${e.message}',
        name: 'UserRepository.getUser',
        error: e,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unexpected error during getUser for uid=$uid: $e',
        name: 'UserRepository.getUser',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    developer.log(
      'Starting updateUser for uid=$uid with data keys: ${data.keys.join(', ')}',
      name: 'UserRepository.updateUser',
    );

    try {
      await FirestoreService.runSafely(
        path: 'users/$uid',
        operation: 'updateUser',
        action: () => _usersCollection.doc(uid).update(data),
      );
      developer.log(
        'Successfully updated user document for uid=$uid',
        name: 'UserRepository.updateUser',
      );
    } on FirebaseException catch (e) {
      // If document doesn't exist, create it with merge instead of updating
      if (e.code == 'not-found') {
        developer.log(
          'User document not found for uid=$uid during update - creating with merged data',
          name: 'UserRepository.updateUser',
        );
        try {
          await FirestoreService.runSafely(
            path: 'users/$uid',
            operation: 'updateUser (fallback set)',
            action: () =>
                _usersCollection.doc(uid).set(data, SetOptions(merge: true)),
          );
          developer.log(
            'Successfully created user document for uid=$uid with merged data',
            name: 'UserRepository.updateUser',
          );
        } catch (fallbackError) {
          developer.log(
            'Fallback set operation failed for uid=$uid: $fallbackError',
            name: 'UserRepository.updateUser',
            error: fallbackError,
          );
          rethrow;
        }
      } else {
        developer.log(
          'FirebaseException during updateUser for uid=$uid: ${e.code} - ${e.message}',
          name: 'UserRepository.updateUser',
          error: e,
        );
        rethrow;
      }
    } catch (e, st) {
      developer.log(
        'Unexpected error during updateUser for uid=$uid: $e',
        name: 'UserRepository.updateUser',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}

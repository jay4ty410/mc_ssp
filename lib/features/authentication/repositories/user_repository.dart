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
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != user.uid) {
      print(
        '[UserRepository] currentUid ($currentUid) != user.uid (${user.uid})',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Authenticated UID does not match the created user UID',
      );
    }

    final userDoc = _usersCollection.doc(user.uid);
    final batch = _firestore.batch();

    batch.set(userDoc, user.toMap());
    batch.set(userDoc.collection('profile').doc('profile'), {
      'displayName': user.displayName,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'role': user.role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    batch.set(
      userDoc.collection('settings').doc('settings'),
      SettingsModel().toMap(),
      SetOptions(merge: true),
    );
    batch.set(
      userDoc.collection('statistics').doc('statistics'),
      StatisticsModel().toMap(),
      SetOptions(merge: true),
    );

    await FirestoreService.runSafely(
      path: 'users/${user.uid}',
      operation: 'createUser',
      action: () => batch.commit(),
    );
  }

  Future<UserModel?> getUser(String uid) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != uid) {
      print(
        '[UserRepository] getUser called with uid=$uid but currentUid=$currentUid',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot access another user\'s data',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$uid',
      operation: 'getUser',
      action: () => _usersCollection.doc(uid).get(),
    );

    if (!snapshot.exists) {
      return null;
    }

    return UserModel.fromMap((snapshot.data() ?? {}) as Map<String, dynamic>);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != uid) {
      print(
        '[UserRepository] updateUser called with uid=$uid but currentUid=$currentUid',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update another user\'s data',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$uid',
      operation: 'updateUser',
      action: () => _usersCollection.doc(uid).update(data),
    );
  }
}

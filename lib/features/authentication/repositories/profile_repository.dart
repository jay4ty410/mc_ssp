import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/settings_model.dart';
import '../models/statistics_model.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _profileDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('profile');
  }

  DocumentReference<Map<String, dynamic>> _settingsDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('settings');
  }

  DocumentReference<Map<String, dynamic>> _statisticsDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('statistics')
        .doc('statistics');
  }

  Future<void> setProfile(String userId, Map<String, dynamic> data) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] setProfile uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot modify another user\'s profile',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/profile',
      operation: 'setProfile',
      action: () => _profileDoc(userId).set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    );
  }

  Future<void> setSettings(String userId, SettingsModel settings) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] setSettings uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot modify another user\'s settings',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/settings',
      operation: 'setSettings',
      action: () =>
          _settingsDoc(userId).set(settings.toMap(), SetOptions(merge: true)),
    );
  }

  Future<void> setStatistics(String userId, StatisticsModel statistics) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] setStatistics uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot modify another user\'s statistics',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/statistics',
      operation: 'setStatistics',
      action: () => _statisticsDoc(
        userId,
      ).set(statistics.toMap(), SetOptions(merge: true)),
    );
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] getProfile uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read another user\'s profile',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/profile',
      operation: 'getProfile',
      action: () => _profileDoc(userId).get(),
    );

    return snapshot.exists ? snapshot.data() : null;
  }

  Future<SettingsModel?> getSettings(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] getSettings uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read another user\'s settings',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/settings',
      operation: 'getSettings',
      action: () => _settingsDoc(userId).get(),
    );

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return SettingsModel.fromMap(snapshot.data()!);
  }

  Future<StatisticsModel?> getStatistics(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      print(
        '[ProfileRepository] getStatistics uid mismatch $currentUid != $userId',
      );
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read another user\'s statistics',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/statistics',
      operation: 'getStatistics',
      action: () => _statisticsDoc(userId).get(),
    );

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return StatisticsModel.fromMap(snapshot.data()!);
  }
}

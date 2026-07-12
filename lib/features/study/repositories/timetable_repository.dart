import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';

class TimetableRepository {
  TimetableRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _timetablesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('generated_timetables');
  }

  CollectionReference<Map<String, dynamic>> _sessionsCollection(
    String userId,
    String timetableId,
  ) {
    return _timetablesCollection(
      userId,
    ).doc(timetableId).collection('sessions');
  }

  Future<String> createTimetable(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create timetable for another user',
      );
    }

    final ref = await FirestoreService.runSafely(
      path: 'users/$userId/generated_timetables',
      operation: 'createTimetable',
      action: () => _timetablesCollection(
        userId,
      ).add({...data, 'createdAt': FieldValue.serverTimestamp()}),
    );
    return (ref as DocumentReference<Map<String, dynamic>>).id;
  }

  Future<void> addSessions(
    String userId,
    String timetableId,
    List<Map<String, dynamic>> sessions,
  ) async {
    if (sessions.isEmpty) {
      return;
    }

    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot add sessions for another user',
      );
    }

    final batch = _firestore.batch();
    for (final session in sessions) {
      final ref = _sessionsCollection(userId, timetableId).doc();
      batch.set(ref, session);
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/generated_timetables/$timetableId/sessions',
      operation: 'addSessions',
      action: () => batch.commit(),
    );
  }

  Future<List<Map<String, dynamic>>> getTimetables(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read timetables for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/generated_timetables',
      operation: 'getTimetables',
      action: () => _timetablesCollection(
        userId,
      ).orderBy('createdAt', descending: true).get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }
}

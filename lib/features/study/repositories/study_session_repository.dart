import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/study_session_model.dart';

class StudySessionRepository {
  StudySessionRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('study_sessions');
  }

  Future<void> create(String userId, StudySessionModel session) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create study session for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/study_sessions/${session.id}',
      operation: 'createStudySession',
      action: () => _collection(userId).doc(session.id).set(session.toMap()),
    );
  }

  Future<void> createMany(
    String userId,
    List<StudySessionModel> sessions,
  ) async {
    if (sessions.isEmpty) {
      return;
    }

    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create study sessions for another user',
      );
    }

    final batch = _firestore.batch();
    for (final session in sessions) {
      batch.set(_collection(userId).doc(session.id), session.toMap());
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/study_sessions',
      operation: 'createManyStudySessions',
      action: () => batch.commit(),
    );
  }

  Future<List<StudySessionModel>> getByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot query study sessions for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/study_sessions',
      operation: 'getByDateRange',
      action: () => _collection(userId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('startTime')
          .get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => StudySessionModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> update(
    String userId,
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update study session for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/study_sessions/$sessionId',
      operation: 'updateStudySession',
      action: () => _collection(userId).doc(sessionId).update(data),
    );
  }

  Future<void> delete(String userId, String sessionId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot delete study session for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/study_sessions/$sessionId',
      operation: 'deleteStudySession',
      action: () => _collection(userId).doc(sessionId).delete(),
    );
  }
}

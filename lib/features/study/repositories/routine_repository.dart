import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/daily_routine_model.dart';

class RoutineRepository {
  RoutineRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_routines');
  }

  Future<List<DailyRoutineModel>> getRoutineForToday(
    String userId,
    DateTime date,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read routines for another user',
      );
    }

    final dayKey = _formatDateKey(date);

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/daily_routines',
      operation: 'getRoutineForToday',
      action: () => _collection(
        userId,
      ).where('date', isEqualTo: dayKey).orderBy('startTime').get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => DailyRoutineModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<DailyRoutineModel>> getDailyRoutineByDate(
    String userId,
    DateTime date,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read routines for another user',
      );
    }

    final dayKey = _formatDateKey(date);

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/daily_routines',
      operation: 'getDailyRoutineByDate',
      action: () => _collection(
        userId,
      ).where('date', isEqualTo: dayKey).orderBy('startTime').get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => DailyRoutineModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> generateDailyRoutine(
    String userId,
    List<DailyRoutineModel> activities,
  ) async {
    if (activities.isEmpty) {
      return;
    }

    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot generate routines for another user',
      );
    }

    final batch = _firestore.batch();

    for (final activity in activities) {
      final docRef = _collection(userId).doc(activity.id);
      final payload = activity.toMap()..['userId'] = userId;
      batch.set(docRef, payload);
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/daily_routines',
      operation: 'generateDailyRoutine',
      action: () => batch.commit(),
    );
  }

  String _formatDateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

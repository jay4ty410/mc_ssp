import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/event_model.dart';

class CalendarRepository {
  CalendarRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('events');
  }

  Future<void> create(String userId, EventModel event) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create event for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/events/${event.id}',
      operation: 'createEvent',
      action: () => _collection(userId).doc(event.id).set(event.toMap()),
    );
  }

  Future<EventModel?> getById(String userId, String eventId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read event for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/events/$eventId',
      operation: 'getEventById',
      action: () => _collection(userId).doc(eventId).get(),
    );

    if (!snapshot.exists || snapshot.data() == null) return null;
    return EventModel.fromMap(snapshot.data()!);
  }

  Future<void> update(
    String userId,
    String eventId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update event for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/events/$eventId',
      operation: 'updateEvent',
      action: () => _collection(userId).doc(eventId).update(data),
    );
  }

  Future<void> delete(String userId, String eventId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot delete event for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/events/$eventId',
      operation: 'deleteEvent',
      action: () => _collection(userId).doc(eventId).delete(),
    );
  }

  Future<List<EventModel>> getEventsForMonth(
    String userId,
    DateTime month,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot query events for another user',
      );
    }

    final start = DateTime(month.year, month.month, 1);
    final nextMonth = (month.month == 12)
        ? DateTime(month.year + 1, 1, 1)
        : DateTime(month.year, month.month + 1, 1);

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/events',
      operation: 'getEventsForMonth',
      action: () => _collection(userId)
          .where(
            'startDateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
          )
          .where('startDateTime', isLessThan: Timestamp.fromDate(nextMonth))
          .orderBy('startDateTime')
          .get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => EventModel.fromMap(doc.data()))
        .toList();
  }
}

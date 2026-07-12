import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../../../shared/models/reminder_model.dart';

class ReminderRepository {
  ReminderRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('reminders');
  }

  Future<void> create(String userId, ReminderModel reminder) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create reminder for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/reminders/${reminder.id}',
      operation: 'createReminder',
      action: () => _collection(userId).doc(reminder.id).set({
        'id': reminder.id,
        'title': reminder.title,
        'description': reminder.description,
        'reminderDateTime': Timestamp.fromDate(reminder.reminderTime),
        'repeat': reminder.repeat,
        'notificationEnabled': reminder.notificationEnabled,
        'completed': reminder.isCompleted,
        'createdAt': Timestamp.fromDate(reminder.createdAt),
      }),
    );
  }

  Future<List<ReminderModel>> getUpcoming(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read reminders for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/reminders',
      operation: 'getUpcomingReminders',
      action: () => _collection(
        userId,
      ).where('completed', isEqualTo: false).orderBy('reminderDateTime').get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs.map((doc) {
      final data = doc.data();
      return ReminderModel(
        id: doc.id,
        title: data['title']?.toString() ?? '',
        description: data['description']?.toString(),
        reminderTime: (data['reminderDateTime'] as Timestamp).toDate(),
        repeat: data['repeat']?.toString() ?? 'none',
        isCompleted: data['completed'] ?? false,
        notificationEnabled: data['notificationEnabled'] ?? true,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  Future<void> update(
    String userId,
    String reminderId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update reminder for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/reminders/$reminderId',
      operation: 'updateReminder',
      action: () => _collection(userId).doc(reminderId).update(data),
    );
  }

  Future<void> delete(String userId, String reminderId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot delete reminder for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/reminders/$reminderId',
      operation: 'deleteReminder',
      action: () => _collection(userId).doc(reminderId).delete(),
    );
  }
}

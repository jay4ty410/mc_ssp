import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  TaskRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  Future<void> create(String userId, TaskModel task) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create task for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/tasks/${task.id}',
      operation: 'createTask',
      action: () => _collection(userId).doc(task.id).set(task.toMap()),
    );
  }

  Future<TaskModel?> getById(String userId, String taskId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read task for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/tasks/$taskId',
      operation: 'getTaskById',
      action: () => _collection(userId).doc(taskId).get(),
    );

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return TaskModel.fromMap(snapshot.data()!);
  }

  Future<void> update(
    String userId,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update task for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/tasks/$taskId',
      operation: 'updateTask',
      action: () => _collection(userId).doc(taskId).update(data),
    );
  }

  Future<void> delete(String userId, String taskId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot delete task for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/tasks/$taskId',
      operation: 'deleteTask',
      action: () => _collection(userId).doc(taskId).delete(),
    );
  }

  Future<List<TaskModel>> getUpcomingTasks(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot query tasks for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/tasks',
      operation: 'getUpcomingTasks',
      action: () => _collection(
        userId,
      ).where('status', isEqualTo: 'pending').orderBy('dueDate').get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => TaskModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<TaskModel>> getTasksByStatus(String userId, String status) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot query tasks for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/tasks',
      operation: 'getTasksByStatus',
      action: () => _collection(
        userId,
      ).where('status', isEqualTo: status).orderBy('dueDate').get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => TaskModel.fromMap(doc.data()))
        .toList();
  }
}

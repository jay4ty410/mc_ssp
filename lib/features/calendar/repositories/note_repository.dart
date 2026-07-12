import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mc_ssp/services/firestore_service.dart';
import '../models/note_model.dart';

class NoteRepository {
  NoteRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  Future<void> create(String userId, NoteModel note) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot create note for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/notes/${note.id}',
      operation: 'createNote',
      action: () => _collection(userId).doc(note.id).set(note.toMap()),
    );
  }

  Future<List<NoteModel>> getRecent(String userId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot read notes for another user',
      );
    }

    final snapshot = await FirestoreService.runSafely(
      path: 'users/$userId/notes',
      operation: 'getRecentNotes',
      action: () => _collection(
        userId,
      ).orderBy('updatedAt', descending: true).limit(20).get(),
    );

    return (snapshot as QuerySnapshot<Map<String, dynamic>>).docs
        .map((doc) => NoteModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> update(
    String userId,
    String noteId,
    Map<String, dynamic> data,
  ) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot update note for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/notes/$noteId',
      operation: 'updateNote',
      action: () => _collection(userId).doc(noteId).update(data),
    );
  }

  Future<void> delete(String userId, String noteId) async {
    final currentUid = FirestoreService.getCurrentUidOrThrow();
    if (currentUid != userId) {
      throw FirebaseAuthException(
        code: 'uid-mismatch',
        message: 'Cannot delete note for another user',
      );
    }

    await FirestoreService.runSafely(
      path: 'users/$userId/notes/$noteId',
      operation: 'deleteNote',
      action: () => _collection(userId).doc(noteId).delete(),
    );
  }
}

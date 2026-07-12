import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Centralized Firestore helpers: UID checks, logging, and safe wrappers.
class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String getCurrentUidOrThrow() {
    final user = _auth.currentUser;
    if (user == null) {
      developer.log(
        'No authenticated user available',
        name: 'FirestoreService',
      );
      throw FirebaseAuthException(
        code: 'no-auth',
        message: 'No authenticated user. Please sign in first.',
      );
    }
    return user.uid;
  }

  static DocumentReference<Map<String, dynamic>> userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  static Future<T> runSafely<T>({
    required String path,
    required String operation,
    required Future<T> Function() action,
  }) async {
    try {
      developer.log(
        '$operation -> $path (uid=${_auth.currentUser?.uid})',
        name: 'FirestoreService',
      );
      return await action();
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException during $operation on $path: ${e.code} ${e.message}',
        name: 'FirestoreService',
        error: e,
      );
      rethrow;
    } on FirebaseException catch (e) {
      developer.log(
        'FirebaseException during $operation on $path: ${e.code} ${e.message}',
        name: 'FirestoreService',
        error: e,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unknown error during $operation on $path: $e',
        name: 'FirestoreService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}

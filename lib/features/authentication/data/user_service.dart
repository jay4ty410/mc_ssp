import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service to fetch authenticated user's profile from Firestore.
class UserService {
  UserService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Returns a Map of user profile fields or null if not available.
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final docRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return null;

    return snapshot.data();
  }
}

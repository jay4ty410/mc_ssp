import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Diagnostic utility to help troubleshoot Firebase Auth and Firestore sync issues.
///
/// This utility provides methods to verify the state of authentication and Firestore
/// data, helping to identify synchronization problems early.
class AuthDiagnostics {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Performs a complete diagnostic check of the current user's auth and Firestore state.
  /// Returns a detailed report that can be logged or displayed for debugging.
  static Future<DiagnosticReport> performFullDiagnostic() async {
    final report = DiagnosticReport();
    final timestamp = DateTime.now();

    developer.log(
      'Starting full authentication diagnostic at ${timestamp.toIso8601String()}',
      name: 'AuthDiagnostics',
    );

    // Check Auth State
    final currentUser = _auth.currentUser;
    report.authUserExists = currentUser != null;
    report.authenticatedUid = currentUser?.uid;
    report.authenticatedEmail = currentUser?.email;
    report.authUserEmailVerified = currentUser?.emailVerified;

    developer.log(
      'Auth State: uid=${currentUser?.uid}, email=${currentUser?.email}, verified=${currentUser?.emailVerified}',
      name: 'AuthDiagnostics',
    );

    // Check Firestore User Document
    if (currentUser != null) {
      try {
        developer.log(
          'Checking Firestore user document for uid=${currentUser.uid}',
          name: 'AuthDiagnostics',
        );
        final userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        report.firestoreUserDocExists = userDoc.exists;
        if (userDoc.exists) {
          report.firestoreUserDocData = userDoc.data();
          developer.log(
            'Firestore user document exists with data keys: ${userDoc.data()?.keys.join(', ')}',
            name: 'AuthDiagnostics',
          );
        } else {
          developer.log(
            'Firestore user document DOES NOT EXIST for uid=${currentUser.uid}',
            name: 'AuthDiagnostics',
          );
        }
      } catch (e) {
        report.firestoreReadError = e.toString();
        developer.log(
          'Error reading Firestore user document: $e',
          name: 'AuthDiagnostics',
          error: e,
        );
      }

      // Check Firestore Subcollections
      try {
        developer.log(
          'Checking Firestore subcollections for uid=${currentUser.uid}',
          name: 'AuthDiagnostics',
        );
        final profileDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('profile')
            .doc('profile')
            .get();

        report.profileSubcollectionExists = profileDoc.exists;
        developer.log(
          'Profile subcollection exists: ${profileDoc.exists}',
          name: 'AuthDiagnostics',
        );

        final settingsDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('settings')
            .doc('settings')
            .get();

        report.settingsSubcollectionExists = settingsDoc.exists;
        developer.log(
          'Settings subcollection exists: ${settingsDoc.exists}',
          name: 'AuthDiagnostics',
        );

        final statsDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('statistics')
            .doc('statistics')
            .get();

        report.statisticsSubcollectionExists = statsDoc.exists;
        developer.log(
          'Statistics subcollection exists: ${statsDoc.exists}',
          name: 'AuthDiagnostics',
        );
      } catch (e) {
        report.subcollectionReadError = e.toString();
        developer.log(
          'Error reading subcollections: $e',
          name: 'AuthDiagnostics',
          error: e,
        );
      }
    }

    report.timestamp = timestamp;
    return report;
  }

  /// Verifies that the Firestore security rules allow the current user to read/write.
  /// This is helpful to identify permission-related issues.
  static Future<bool> verifyFirestorePermissions() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      developer.log(
        'Cannot verify permissions: no authenticated user',
        name: 'AuthDiagnostics',
      );
      return false;
    }

    try {
      developer.log(
        'Verifying Firestore permissions for uid=${currentUser.uid}',
        name: 'AuthDiagnostics',
      );

      // Try a test write to a temporary document
      final testDocRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('_permission_test')
          .doc('test');

      await testDocRef.set({'test': true});
      await testDocRef.delete();

      developer.log(
        'Firestore permissions verified successfully for uid=${currentUser.uid}',
        name: 'AuthDiagnostics',
      );
      return true;
    } catch (e) {
      developer.log(
        'Firestore permissions check failed for uid=${currentUser.uid}: $e',
        name: 'AuthDiagnostics',
        error: e,
      );
      return false;
    }
  }

  /// Logs a summary of the diagnostic report.
  static void logDiagnosticReport(DiagnosticReport report) {
    developer.log('''
=== Authentication Diagnostic Report ===
Timestamp: ${report.timestamp}

AUTH STATE:
- User Exists: ${report.authUserExists}
- UID: ${report.authenticatedUid}
- Email: ${report.authenticatedEmail}
- Email Verified: ${report.authUserEmailVerified}

FIRESTORE STATE:
- User Document Exists: ${report.firestoreUserDocExists}
- Profile Subcollection: ${report.profileSubcollectionExists}
- Settings Subcollection: ${report.settingsSubcollectionExists}
- Statistics Subcollection: ${report.statisticsSubcollectionExists}

ERRORS:
- Firestore Read Error: ${report.firestoreReadError ?? 'None'}
- Subcollection Read Error: ${report.subcollectionReadError ?? 'None'}

DATA KEYS:
- User Document Keys: ${report.firestoreUserDocData?.keys.join(', ') ?? 'N/A'}
=== End Report ===
      ''', name: 'AuthDiagnostics');
  }
}

/// Represents the result of a diagnostic check.
class DiagnosticReport {
  DateTime? timestamp;

  // Auth state
  bool authUserExists = false;
  String? authenticatedUid;
  String? authenticatedEmail;
  bool? authUserEmailVerified;

  // Firestore state
  bool firestoreUserDocExists = false;
  bool profileSubcollectionExists = false;
  bool settingsSubcollectionExists = false;
  bool statisticsSubcollectionExists = false;

  // Data
  Map<String, dynamic>? firestoreUserDocData;

  // Errors
  String? firestoreReadError;
  String? subcollectionReadError;

  /// Returns true if the diagnostic found any issues.
  bool get hasIssues =>
      !authUserExists ||
      !firestoreUserDocExists ||
      firestoreReadError != null ||
      subcollectionReadError != null;

  /// Returns a user-friendly description of the current state.
  String getSummary() {
    if (!authUserExists) {
      return 'No authenticated user. Please sign in.';
    }

    if (!firestoreUserDocExists) {
      return 'User is authenticated but Firestore profile document is missing. '
          'This may indicate registration was incomplete.';
    }

    if (firestoreReadError != null) {
      return 'Error reading Firestore data: $firestoreReadError';
    }

    if (subcollectionReadError != null) {
      return 'Error reading Firestore subcollections: $subcollectionReadError';
    }

    return 'Authentication and Firestore state appears healthy.';
  }
}

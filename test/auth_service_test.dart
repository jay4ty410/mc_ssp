import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_ssp/features/authentication/services/auth_service.dart';

void main() {
  group('AuthService error handling', () {
    test(
      'maps FirebaseAuthException configuration-not-found to a helpful message',
      () {
        final error = FirebaseAuthException(
          code: 'configuration-not-found',
          message: 'Configuration not found',
        );

        final message = AuthService.getUserFacingErrorMessage(error);

        expect(message, contains('Firebase authentication'));
        expect(message, contains('configured correctly'));
      },
    );

    test(
      'maps PlatformException configuration-not-found to a helpful message',
      () {
        final error = PlatformException(
          code: 'CONFIGURATION_NOT_FOUND',
          message: 'Configuration not found',
        );

        final message = AuthService.getUserFacingErrorMessage(error);

        expect(message, contains('Firebase authentication'));
        expect(message, contains('configured correctly'));
      },
    );

    test('maps Firestore permission-denied errors to a helpful message', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message:
            'The caller does not have permission to execute the specified operation.',
      );

      final message = AuthService.getUserFacingErrorMessage(error);

      expect(message, contains('Firestore security rules'));
      expect(message, contains('authenticated user'));
    });
  });
}

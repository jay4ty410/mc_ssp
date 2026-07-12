import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_ssp/features/authentication/models/user_model.dart';

void main() {
  group('UserModel serialization', () {
    test('round-trips a user through toMap and fromMap', () {
      final createdAt = DateTime(2026, 7, 11, 10, 30);
      final updatedAt = DateTime(2026, 7, 11, 11, 0);

      final user = UserModel(
        uid: 'abc123',
        email: 'student@example.com',
        displayName: 'Alex Student',
        photoUrl: 'https://example.com/avatar.png',
        createdAt: createdAt,
        updatedAt: updatedAt,
        role: 'student',
        isActive: true,
      );

      final map = user.toMap();
      final restored = UserModel.fromMap(map);

      expect(map['uid'], 'abc123');
      expect(map['createdAt'], isA<Timestamp>());
      expect(restored.uid, user.uid);
      expect(restored.email, user.email);
      expect(restored.displayName, user.displayName);
      expect(restored.photoUrl, user.photoUrl);
      expect(restored.createdAt, createdAt);
      expect(restored.updatedAt, updatedAt);
      expect(restored.role, 'student');
      expect(restored.isActive, isTrue);
    });
  });
}

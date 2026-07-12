import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final bool isActive;
  final bool isVerified;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.role = 'student',
    this.isActive = true,
    this.isVerified = false,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final now = DateTime.now();

    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'createdAt': Timestamp.fromDate(createdAt ?? now),
      'updatedAt': Timestamp.fromDate(updatedAt ?? now),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return UserModel(
      uid: json['uid']?.toString() ?? '',
      email: json['email']?.toString(),
      displayName: json['displayName']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      role: json['role']?.toString() ?? 'student',
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      lastLogin: parseDateTime(json['lastLogin']),
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime? _parseTimestamp(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return UserModel(
      uid: map['uid']?.toString() ?? '',
      email: map['email']?.toString(),
      displayName: map['displayName']?.toString(),
      photoUrl: map['photoUrl']?.toString(),
      role: map['role']?.toString() ?? 'student',
      isActive: map['isActive'] ?? true,
      isVerified: map['isVerified'] ?? false,
      lastLogin: _parseTimestamp(map['lastLogin']),
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  static UserModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return UserModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    UserModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

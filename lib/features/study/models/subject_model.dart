import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String id;
  final String name;
  final String? code;
  final String? color;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubjectModel({
    required this.id,
    required this.name,
    this.code,
    this.color,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  SubjectModel copyWith({
    String? id,
    String? name,
    String? code,
    String? color,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      color: color ?? this.color,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'color': color,
      'description': description,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'color': color,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return SubjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      color: json['color']?.toString(),
      description: json['description']?.toString(),
      isActive: json['isActive'] ?? true,
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return SubjectModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      code: map['code']?.toString(),
      color: map['color']?.toString(),
      description: map['description']?.toString(),
      isActive: map['isActive'] ?? true,
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }

  static SubjectModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return SubjectModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    SubjectModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

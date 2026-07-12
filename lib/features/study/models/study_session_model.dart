import 'package:cloud_firestore/cloud_firestore.dart';

class StudySessionModel {
  StudySessionModel({
    required this.id,
    required this.subjectId,
    required this.startTime,
    required this.endTime,
    required this.sessionType,
    this.completed = false,
    this.generatedAutomatically = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String subjectId;
  final DateTime startTime;
  final DateTime endTime;
  final String sessionType;
  final bool completed;
  final bool generatedAutomatically;
  final DateTime createdAt;

  StudySessionModel copyWith({
    String? id,
    String? subjectId,
    DateTime? startTime,
    DateTime? endTime,
    String? sessionType,
    bool? completed,
    bool? generatedAutomatically,
    DateTime? createdAt,
  }) {
    return StudySessionModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sessionType: sessionType ?? this.sessionType,
      completed: completed ?? this.completed,
      generatedAutomatically:
          generatedAutomatically ?? this.generatedAutomatically,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'sessionType': sessionType,
      'completed': completed,
      'generatedAutomatically': generatedAutomatically,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'sessionType': sessionType,
      'completed': completed,
      'generatedAutomatically': generatedAutomatically,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return StudySessionModel(
      id: json['id']?.toString() ?? '',
      subjectId: json['subjectId']?.toString() ?? '',
      startTime: parseDateTime(json['startTime']) ?? DateTime.now(),
      endTime: parseDateTime(json['endTime']) ?? DateTime.now(),
      sessionType: json['sessionType']?.toString() ?? 'focus',
      completed: json['completed'] ?? false,
      generatedAutomatically: json['generatedAutomatically'] ?? true,
      createdAt: parseDateTime(json['createdAt']),
    );
  }

  factory StudySessionModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return StudySessionModel(
      id: map['id']?.toString() ?? '',
      subjectId: map['subjectId']?.toString() ?? '',
      startTime: parseDateTime(map['startTime']) ?? DateTime.now(),
      endTime: parseDateTime(map['endTime']) ?? DateTime.now(),
      sessionType: map['sessionType']?.toString() ?? 'focus',
      completed: map['completed'] ?? false,
      generatedAutomatically: map['generatedAutomatically'] ?? true,
      createdAt: parseDateTime(map['createdAt']),
    );
  }

  static StudySessionModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return StudySessionModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    StudySessionModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

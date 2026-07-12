import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRoutineModel {
  final String id;
  final String title;
  final String? description;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyRoutineModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  DailyRoutineModel copyWith({
    String? id,
    String? title,
    String? description,
    String? startTime,
    String? endTime,
    String? dayOfWeek,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyRoutineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'dayOfWeek': dayOfWeek,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory DailyRoutineModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return DailyRoutineModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      dayOfWeek: map['dayOfWeek']?.toString() ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }
}

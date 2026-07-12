import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  final String id;

  final String title;

  final String? description;

  /// Reminder date & time
  final DateTime reminderTime;

  /// Optional task association
  final String? taskId;

  /// Optional note association
  final String? noteId;

  /// Repeat options:
  /// none
  /// daily
  /// weekly
  /// monthly
  final String repeat;

  final bool isCompleted;

  final bool notificationEnabled;

  final DateTime createdAt;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description,
    required this.reminderTime,
    this.taskId,
    this.noteId,
    this.repeat = 'none',
    this.isCompleted = false,
    this.notificationEnabled = true,
    required this.createdAt,
  });

  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderTime,
    String? taskId,
    String? noteId,
    String? repeat,
    bool? isCompleted,
    bool? notificationEnabled,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      taskId: taskId ?? this.taskId,
      noteId: noteId ?? this.noteId,
      repeat: repeat ?? this.repeat,
      isCompleted: isCompleted ?? this.isCompleted,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderDateTime': Timestamp.fromDate(reminderTime),
      'taskId': taskId,
      'noteId': noteId,
      'repeat': repeat,
      'completed': isCompleted,
      'notificationEnabled': notificationEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'reminderDateTime': reminderTime.toIso8601String(),
    'taskId': taskId,
    'noteId': noteId,
    'repeat': repeat,
    'completed': isCompleted,
    'notificationEnabled': notificationEnabled,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return ReminderModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      reminderTime:
          parseDateTime(json['reminderDateTime'] ?? json['reminderTime']) ??
          DateTime.now(),
      taskId: json['taskId']?.toString(),
      noteId: json['noteId']?.toString(),
      repeat: json['repeat']?.toString() ?? 'none',
      isCompleted: json['completed'] ?? json['isCompleted'] ?? false,
      notificationEnabled: json['notificationEnabled'] ?? true,
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return ReminderModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      reminderTime:
          parseDateTime(map['reminderDateTime'] ?? map['reminderTime']) ??
          DateTime.now(),
      taskId: map['taskId']?.toString(),
      noteId: map['noteId']?.toString(),
      repeat: map['repeat']?.toString() ?? 'none',
      isCompleted: map['completed'] ?? map['isCompleted'] ?? false,
      notificationEnabled: map['notificationEnabled'] ?? true,
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  static ReminderModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return ReminderModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    ReminderModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

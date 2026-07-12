import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { pending, inProgress, completed }

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String? subject;
  final String category;
  final TaskStatus status;
  final String priority;
  final DateTime createdAt;
  final DateTime dueDate;
  final DateTime? reminderTime;
  final bool isCompleted;
  final int color;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.subject,
    this.category = 'personal',
    this.status = TaskStatus.pending,
    this.priority = 'medium',
    required this.createdAt,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
    this.color = 0xFF4F46E5,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    String? category,
    TaskStatus? status,
    String? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? reminderTime,
    bool? isCompleted,
    int? color,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'category': category,
      'status': status.name,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'reminderTime': reminderTime != null
          ? Timestamp.fromDate(reminderTime!)
          : null,
      'isCompleted': isCompleted,
      'color': color,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'category': category,
      'status': status.name,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'color': color,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      subject: json['subject']?.toString(),
      category: json['category']?.toString() ?? 'personal',
      status: TaskStatus.values.firstWhere(
        (value) => value.name == json['status']?.toString(),
        orElse: () => TaskStatus.pending,
      ),
      priority: json['priority']?.toString() ?? 'medium',
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
      dueDate: parseDateTime(json['dueDate']) ?? DateTime.now(),
      reminderTime: parseDateTime(json['reminderTime']),
      isCompleted: json['isCompleted'] ?? false,
      color: json['color'] is int ? json['color'] as int : 0xFF4F46E5,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      subject: map['subject']?.toString(),
      category: map['category']?.toString() ?? 'personal',
      status: TaskStatus.values.firstWhere(
        (value) => value.name == map['status']?.toString(),
        orElse: () => TaskStatus.pending,
      ),
      priority: map['priority']?.toString() ?? 'medium',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      dueDate: parseDateTime(map['dueDate']) ?? DateTime.now(),
      reminderTime: parseDateTime(map['reminderTime']),
      isCompleted: map['isCompleted'] ?? false,
      color: map['color'] is int ? map['color'] as int : 0xFF4F46E5,
    );
  }

  static TaskModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return TaskModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    TaskModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

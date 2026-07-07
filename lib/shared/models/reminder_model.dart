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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'reminderTime': reminderTime.toIso8601String(),
    'taskId': taskId,
    'noteId': noteId,
    'repeat': repeat,
    'isCompleted': isCompleted,
    'notificationEnabled': notificationEnabled,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      reminderTime: DateTime.parse(json['reminderTime']),
      taskId: json['taskId'],
      noteId: json['noteId'],
      repeat: json['repeat'] ?? 'none',
      isCompleted: json['isCompleted'] ?? false,
      notificationEnabled: json['notificationEnabled'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class TaskModel {
  final String id;
  final String title;
  final String? description;

  /// Course/Subject
  final String? subject;

  /// Assignment, Exam, Personal, etc.
  final String category;

  /// Pending, In Progress, Completed
  final String status;

  /// Low, Medium, High
  final String priority;

  final DateTime createdAt;

  /// Due date
  final DateTime dueDate;

  /// Optional reminder
  final DateTime? reminderTime;

  final bool isCompleted;

  /// UI Color
  final int color;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.subject,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
    required this.color,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    String? category,
    String? status,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'subject': subject,
    'category': category,
    'status': status,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'reminderTime': reminderTime?.toIso8601String(),
    'isCompleted': isCompleted,
    'color': color,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subject: json['subject'],
      category: json['category'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: DateTime.parse(json['dueDate']),
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      color: json['color'],
    );
  }
}

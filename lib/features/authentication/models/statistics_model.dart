import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsModel {
  StatisticsModel({
    this.completedTasks = 0,
    this.studyHours = 0,
    this.studyStreak = 0,
    this.productivityScore = 0,
    this.notesCreated = 0,
    this.remindersCompleted = 0,
    this.eventsAttended = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final int completedTasks;
  final double studyHours;
  final int studyStreak;
  final int productivityScore;
  final int notesCreated;
  final int remindersCompleted;
  final int eventsAttended;
  final DateTime updatedAt;

  StatisticsModel copyWith({
    int? completedTasks,
    double? studyHours,
    int? studyStreak,
    int? productivityScore,
    int? notesCreated,
    int? remindersCompleted,
    int? eventsAttended,
    DateTime? updatedAt,
  }) {
    return StatisticsModel(
      completedTasks: completedTasks ?? this.completedTasks,
      studyHours: studyHours ?? this.studyHours,
      studyStreak: studyStreak ?? this.studyStreak,
      productivityScore: productivityScore ?? this.productivityScore,
      notesCreated: notesCreated ?? this.notesCreated,
      remindersCompleted: remindersCompleted ?? this.remindersCompleted,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completedTasks': completedTasks,
      'studyHours': studyHours,
      'studyStreak': studyStreak,
      'productivityScore': productivityScore,
      'notesCreated': notesCreated,
      'remindersCompleted': remindersCompleted,
      'eventsAttended': eventsAttended,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'completedTasks': completedTasks,
      'studyHours': studyHours,
      'studyStreak': studyStreak,
      'productivityScore': productivityScore,
      'notesCreated': notesCreated,
      'remindersCompleted': remindersCompleted,
      'eventsAttended': eventsAttended,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return StatisticsModel(
      completedTasks: json['completedTasks'] is int
          ? json['completedTasks'] as int
          : int.tryParse(json['completedTasks']?.toString() ?? '') ?? 0,
      studyHours: json['studyHours'] is num
          ? (json['studyHours'] as num).toDouble()
          : double.tryParse(json['studyHours']?.toString() ?? '') ?? 0,
      studyStreak: json['studyStreak'] is int
          ? json['studyStreak'] as int
          : int.tryParse(json['studyStreak']?.toString() ?? '') ?? 0,
      productivityScore: json['productivityScore'] is int
          ? json['productivityScore'] as int
          : int.tryParse(json['productivityScore']?.toString() ?? '') ?? 0,
      notesCreated: json['notesCreated'] is int
          ? json['notesCreated'] as int
          : int.tryParse(json['notesCreated']?.toString() ?? '') ?? 0,
      remindersCompleted: json['remindersCompleted'] is int
          ? json['remindersCompleted'] as int
          : int.tryParse(json['remindersCompleted']?.toString() ?? '') ?? 0,
      eventsAttended: json['eventsAttended'] is int
          ? json['eventsAttended'] as int
          : int.tryParse(json['eventsAttended']?.toString() ?? '') ?? 0,
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }

  factory StatisticsModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return StatisticsModel(
      completedTasks: map['completedTasks'] is int
          ? map['completedTasks'] as int
          : int.tryParse(map['completedTasks']?.toString() ?? '') ?? 0,
      studyHours: map['studyHours'] is num
          ? (map['studyHours'] as num).toDouble()
          : double.tryParse(map['studyHours']?.toString() ?? '') ?? 0,
      studyStreak: map['studyStreak'] is int
          ? map['studyStreak'] as int
          : int.tryParse(map['studyStreak']?.toString() ?? '') ?? 0,
      productivityScore: map['productivityScore'] is int
          ? map['productivityScore'] as int
          : int.tryParse(map['productivityScore']?.toString() ?? '') ?? 0,
      notesCreated: map['notesCreated'] is int
          ? map['notesCreated'] as int
          : int.tryParse(map['notesCreated']?.toString() ?? '') ?? 0,
      remindersCompleted: map['remindersCompleted'] is int
          ? map['remindersCompleted'] as int
          : int.tryParse(map['remindersCompleted']?.toString() ?? '') ?? 0,
      eventsAttended: map['eventsAttended'] is int
          ? map['eventsAttended'] as int
          : int.tryParse(map['eventsAttended']?.toString() ?? '') ?? 0,
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  static StatisticsModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return StatisticsModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    StatisticsModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

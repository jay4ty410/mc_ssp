class StudyScheduleModel {
  final String id;
  final String subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudyScheduleModel({
    required this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  StudyScheduleModel copyWith({
    String? id,
    String? subjectId,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyScheduleModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory StudyScheduleModel.fromMap(Map<String, dynamic> map) {
    return StudyScheduleModel(
      id: map['id']?.toString() ?? '',
      subjectId: map['subjectId']?.toString() ?? '',
      dayOfWeek: map['dayOfWeek']?.toString() ?? '',
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      isActive: map['isActive'] ?? true,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

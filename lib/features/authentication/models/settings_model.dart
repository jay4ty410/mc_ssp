import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  SettingsModel({
    this.darkMode = false,
    this.notificationSound = true,
    this.vibration = true,
    this.reminderLeadTimeMinutes = 15,
    this.language = 'en',
    this.timezone = 'UTC',
    this.firstDayOfWeek = 'monday',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final bool darkMode;
  final bool notificationSound;
  final bool vibration;
  final int reminderLeadTimeMinutes;
  final String language;
  final String timezone;
  final String firstDayOfWeek;
  final DateTime updatedAt;

  SettingsModel copyWith({
    bool? darkMode,
    bool? notificationSound,
    bool? vibration,
    int? reminderLeadTimeMinutes,
    String? language,
    String? timezone,
    String? firstDayOfWeek,
    DateTime? updatedAt,
  }) {
    return SettingsModel(
      darkMode: darkMode ?? this.darkMode,
      notificationSound: notificationSound ?? this.notificationSound,
      vibration: vibration ?? this.vibration,
      reminderLeadTimeMinutes:
          reminderLeadTimeMinutes ?? this.reminderLeadTimeMinutes,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notificationSound': notificationSound,
      'vibration': vibration,
      'reminderLeadTimeMinutes': reminderLeadTimeMinutes,
      'language': language,
      'timezone': timezone,
      'firstDayOfWeek': firstDayOfWeek,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'notificationSound': notificationSound,
      'vibration': vibration,
      'reminderLeadTimeMinutes': reminderLeadTimeMinutes,
      'language': language,
      'timezone': timezone,
      'firstDayOfWeek': firstDayOfWeek,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return SettingsModel(
      darkMode: json['darkMode'] ?? false,
      notificationSound: json['notificationSound'] ?? true,
      vibration: json['vibration'] ?? true,
      reminderLeadTimeMinutes: json['reminderLeadTimeMinutes'] is int
          ? json['reminderLeadTimeMinutes'] as int
          : int.tryParse(json['reminderLeadTimeMinutes']?.toString() ?? '') ??
                15,
      language: json['language']?.toString() ?? 'en',
      timezone: json['timezone']?.toString() ?? 'UTC',
      firstDayOfWeek: json['firstDayOfWeek']?.toString() ?? 'monday',
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return SettingsModel(
      darkMode: map['darkMode'] ?? false,
      notificationSound: map['notificationSound'] ?? true,
      vibration: map['vibration'] ?? true,
      reminderLeadTimeMinutes: map['reminderLeadTimeMinutes'] is int
          ? map['reminderLeadTimeMinutes'] as int
          : int.tryParse(map['reminderLeadTimeMinutes']?.toString() ?? '') ??
                15,
      language: map['language']?.toString() ?? 'en',
      timezone: map['timezone']?.toString() ?? 'UTC',
      firstDayOfWeek: map['firstDayOfWeek']?.toString() ?? 'monday',
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  static SettingsModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return SettingsModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    SettingsModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

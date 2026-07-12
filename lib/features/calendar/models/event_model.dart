import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String eventType;
  final bool isAllDay;
  final String? organizer;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.startDateTime,
    required this.endDateTime,
    this.eventType = 'meeting',
    this.isAllDay = false,
    this.organizer,
    required this.createdAt,
    required this.updatedAt,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? eventType,
    bool? isAllDay,
    String? organizer,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      eventType: eventType ?? this.eventType,
      isAllDay: isAllDay ?? this.isAllDay,
      organizer: organizer ?? this.organizer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'eventType': eventType,
      'isAllDay': isAllDay,
      'organizer': organizer,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'eventType': eventType,
      'isAllDay': isAllDay,
      'organizer': organizer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      startDateTime: parseDateTime(json['startDateTime']) ?? DateTime.now(),
      endDateTime: parseDateTime(json['endDateTime']) ?? DateTime.now(),
      eventType: json['eventType']?.toString() ?? 'meeting',
      isAllDay: json['isAllDay'] ?? false,
      organizer: json['organizer']?.toString(),
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return EventModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      location: map['location']?.toString(),
      startDateTime: parseDateTime(map['startDateTime']) ?? DateTime.now(),
      endDateTime: parseDateTime(map['endDateTime']) ?? DateTime.now(),
      eventType: map['eventType']?.toString() ?? 'meeting',
      isAllDay: map['isAllDay'] ?? false,
      organizer: map['organizer']?.toString(),
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }

  static EventModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return EventModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    EventModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

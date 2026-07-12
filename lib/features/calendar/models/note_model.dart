import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final String? subject;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int color;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.subject,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
    this.color = 0xFFF8FAFC,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? subject,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? color,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'subject': subject,
      'isPinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'color': color,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'subject': subject,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return NoteModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      subject: json['subject']?.toString(),
      isPinned: json['isPinned'] ?? false,
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(json['updatedAt']) ?? DateTime.now(),
      color: json['color'] is int ? json['color'] as int : 0xFFF8FAFC,
    );
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(Object? value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return NoteModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      subject: map['subject']?.toString(),
      isPinned: map['isPinned'] ?? false,
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']) ?? DateTime.now(),
      color: map['color'] is int ? map['color'] as int : 0xFFF8FAFC,
    );
  }

  static NoteModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return NoteModel.fromMap(snapshot.data() ?? {});
  }

  static Map<String, Object?> toFirestore(
    NoteModel model,
    SetOptions? options,
  ) {
    return model.toMap();
  }
}

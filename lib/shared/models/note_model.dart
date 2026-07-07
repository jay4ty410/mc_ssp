class NoteModel {
  final String id;

  final String title;

  final String content;

  /// Optional subject/course
  final String? subject;

  /// Favorite/Pinned note
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
    required this.color,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'subject': subject,
    'isPinned': isPinned,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'color': color,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      subject: json['subject'],
      isPinned: json['isPinned'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      color: json['color'],
    );
  }
}

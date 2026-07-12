import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_ssp/features/authentication/models/settings_model.dart';
import 'package:mc_ssp/features/authentication/models/statistics_model.dart';
import 'package:mc_ssp/features/calendar/models/event_model.dart';
import 'package:mc_ssp/features/calendar/models/task_model.dart';
import 'package:mc_ssp/features/study/models/study_session_model.dart';

void main() {
  group('Firestore schema models', () {
    test('SettingsModel serializes and deserializes timestamps safely', () {
      final model = SettingsModel(
        darkMode: true,
        notificationSound: false,
        vibration: true,
        reminderLeadTimeMinutes: 20,
        language: 'en',
        timezone: 'UTC',
        firstDayOfWeek: 'monday',
      );

      final map = model.toMap();
      final decoded = SettingsModel.fromMap(map);

      expect(map['darkMode'], isTrue);
      expect(decoded.darkMode, isTrue);
      expect(decoded.language, 'en');
      expect(decoded.timezone, 'UTC');
    });

    test('StatisticsModel keeps aggregate counters as numbers', () {
      final model = StatisticsModel(
        completedTasks: 10,
        studyHours: 25.5,
        studyStreak: 4,
        productivityScore: 88,
        notesCreated: 12,
        remindersCompleted: 7,
        eventsAttended: 3,
      );

      final decoded = StatisticsModel.fromMap(model.toMap());

      expect(decoded.completedTasks, 10);
      expect(decoded.studyHours, 25.5);
      expect(decoded.productivityScore, 88);
    });

    test('StudySessionModel preserves session metadata', () {
      final model = StudySessionModel(
        id: 'session-1',
        subjectId: 'subject-1',
        startTime: DateTime(2026, 7, 12, 8, 0),
        endTime: DateTime(2026, 7, 12, 9, 0),
        sessionType: 'focus',
        completed: false,
        generatedAutomatically: true,
      );

      final decoded = StudySessionModel.fromMap(model.toMap());

      expect(decoded.subjectId, 'subject-1');
      expect(decoded.sessionType, 'focus');
      expect(decoded.generatedAutomatically, isTrue);
      expect(decoded.completed, isFalse);
    });

    test('TaskModel supports json round-trip and firestore conversion', () {
      final model = TaskModel(
        id: 'task-1',
        title: 'Submit report',
        description: 'Draft and send',
        category: 'study',
        dueDate: DateTime(2026, 7, 20, 12),
        createdAt: DateTime(2026, 7, 10),
        reminderTime: DateTime(2026, 7, 19, 10),
        status: TaskStatus.pending,
        priority: 'high',
      );

      final json = model.toJson();
      final decoded = TaskModel.fromJson(json);
      final firestoreMap = TaskModel.toFirestore(model, null);

      expect(decoded.title, 'Submit report');
      expect(decoded.priority, 'high');
      expect(firestoreMap['title'], 'Submit report');
      expect(json['id'], 'task-1');
    });

    test('EventModel parses timestamps from firestore snapshots safely', () {
      final model = EventModel(
        id: 'event-1',
        title: 'Lab review',
        startDateTime: DateTime(2026, 7, 12, 14),
        endDateTime: DateTime(2026, 7, 12, 16),
        createdAt: DateTime(2026, 7, 10),
        updatedAt: DateTime(2026, 7, 10),
      );

      final json = model.toJson();
      final decoded = EventModel.fromJson(json);
      final snapshot = FakeDocumentSnapshot({'id': 'event-1', ...json});
      final converted = EventModel.fromFirestore(snapshot, null);

      expect(decoded.title, 'Lab review');
      expect(converted.title, 'Lab review');
      expect(converted.startDateTime.year, 2026);
    });
  });
}

class FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  FakeDocumentSnapshot(this._data);

  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  String get id => _data['id']?.toString() ?? '';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

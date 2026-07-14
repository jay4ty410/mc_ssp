import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/repositories/auth_repository.dart';
import '../features/authentication/repositories/profile_repository.dart';
import '../features/authentication/repositories/user_repository.dart';
import '../features/authentication/services/user_auth_service.dart';
import '../features/authentication/data/user_service.dart';
import '../features/calendar/repositories/calendar_repository.dart';
import '../features/calendar/repositories/note_repository.dart';
import '../features/calendar/repositories/reminder_repository.dart';
import '../features/calendar/repositories/task_repository.dart';
import '../features/calendar/controllers/task_controller.dart';
import '../features/calendar/controllers/calendar_controller.dart';
import '../features/study/repositories/routine_repository.dart';
import '../features/study/repositories/study_session_repository.dart';
import '../features/study/repositories/timetable_repository.dart';
import '../features/study/controllers/routine_controller.dart';
import 'firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.read(firebaseAuthProvider);

  return AuthRepository(auth: auth);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return TaskRepository(firestore: firestore);
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return CalendarRepository(firestore: firestore);
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return RoutineRepository(firestore: firestore);
});

final taskControllerProvider = StateNotifierProvider<TaskController, TaskState>(
  (ref) {
    final repo = ref.read(taskRepositoryProvider);
    return TaskController(repo);
  },
);

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, CalendarState>((ref) {
      final repo = ref.read(calendarRepositoryProvider);
      return CalendarController(repo);
    });

final routineControllerProvider =
    StateNotifierProvider<RoutineController, RoutineState>((ref) {
      final repo = ref.read(routineRepositoryProvider);
      return RoutineController(repo);
    });

final userAuthServiceProvider = Provider<UserAuthService>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firestoreProvider);

  return UserAuthService(
    auth: auth,
    userRepository: UserRepository(firestore: firestore),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return UserRepository(firestore: firestore);
});

final userServiceProvider = Provider<UserService>((ref) {
  final firestore = ref.read(firestoreProvider);
  // Provide FirebaseAuth.instance indirectly via service constructor default
  return UserService(firestore: firestore);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ProfileRepository(firestore: firestore);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return NoteRepository(firestore: firestore);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ReminderRepository(firestore: firestore);
});

final studySessionRepositoryProvider = Provider<StudySessionRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return StudySessionRepository(firestore: firestore);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return TimetableRepository(firestore: firestore);
});

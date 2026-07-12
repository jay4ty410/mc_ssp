import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/daily_routine_model.dart';
import '../repositories/routine_repository.dart';

class RoutineState {
  final bool isLoading;
  final List<DailyRoutineModel> routines;
  final String? error;

  const RoutineState({
    this.isLoading = false,
    this.routines = const [],
    this.error,
  });

  RoutineState copyWith({
    bool? isLoading,
    List<DailyRoutineModel>? routines,
    String? error,
  }) {
    return RoutineState(
      isLoading: isLoading ?? this.isLoading,
      routines: routines ?? this.routines,
      error: error,
    );
  }
}

class RoutineController extends StateNotifier<RoutineState> {
  RoutineController(this._repository) : super(const RoutineState());

  final RoutineRepository _repository;

  Future<void> loadByDate(String userId, DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getDailyRoutineByDate(userId, date);
      state = state.copyWith(isLoading: false, routines: list, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateDaily(
    String userId,
    List<DailyRoutineModel> activities,
  ) async {
    try {
      await _repository.generateDailyRoutine(userId, activities);
      await loadByDate(userId, DateTime.now());
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

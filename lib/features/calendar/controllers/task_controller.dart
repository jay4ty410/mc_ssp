import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskState {
  final bool isLoading;
  final List<TaskModel> tasks;
  final String? error;

  const TaskState({this.isLoading = false, this.tasks = const [], this.error});

  TaskState copyWith({bool? isLoading, List<TaskModel>? tasks, String? error}) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      error: error,
    );
  }
}

class TaskController extends StateNotifier<TaskState> {
  TaskController(this._repository) : super(const TaskState());

  final TaskRepository _repository;

  Future<void> loadUpcoming(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getUpcomingTasks(userId);
      state = state.copyWith(isLoading: false, tasks: list, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadByStatus(String userId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getTasksByStatus(userId, status);
      state = state.copyWith(isLoading: false, tasks: list, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> create(String userId, TaskModel task) async {
    try {
      await _repository.create(userId, task);
      await loadUpcoming(userId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> update(
    String userId,
    String taskId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _repository.update(userId, taskId, data);
      await loadUpcoming(userId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

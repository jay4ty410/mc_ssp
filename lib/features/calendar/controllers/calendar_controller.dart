import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event_model.dart';
import '../repositories/calendar_repository.dart';

class CalendarState {
  final bool isLoading;
  final List<EventModel> events;
  final String? error;

  const CalendarState({
    this.isLoading = false,
    this.events = const [],
    this.error,
  });

  CalendarState copyWith({
    bool? isLoading,
    List<EventModel>? events,
    String? error,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error,
    );
  }
}

class CalendarController extends StateNotifier<CalendarState> {
  CalendarController(this._repository) : super(const CalendarState());

  final CalendarRepository _repository;

  Future<void> loadForMonth(String userId, DateTime month) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getEventsForMonth(userId, month);
      state = state.copyWith(isLoading: false, events: list, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> create(String userId, EventModel event) async {
    try {
      await _repository.create(userId, event);
      await loadForMonth(userId, event.startDateTime);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> update(
    String userId,
    String eventId,
    Map<String, dynamic> data,
    DateTime currentMonth,
  ) async {
    try {
      await _repository.update(userId, eventId, data);
      await loadForMonth(userId, currentMonth);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> delete(
    String userId,
    String eventId,
    DateTime currentMonth,
  ) async {
    try {
      await _repository.delete(userId, eventId);
      await loadForMonth(userId, currentMonth);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

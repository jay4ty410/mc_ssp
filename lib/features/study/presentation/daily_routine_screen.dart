import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mc_ssp/providers/firebase_providers.dart';
import 'package:mc_ssp/providers/repository_providers.dart';
import '../controllers/routine_controller.dart';
import '../models/daily_routine_model.dart';

class DailyRoutineScreen extends ConsumerStatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  ConsumerState<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends ConsumerState<DailyRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId != null) {
        ref
            .read(routineControllerProvider.notifier)
            .loadByDate(userId, DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routineState = ref.watch(routineControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Routine')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Expanded(child: _buildBody(routineState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        '${_weekday(now.weekday)}, ${now.day} ${_monthName(now.month)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Your plan for today',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildBody(RoutineState routineState) {
    if (routineState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (routineState.error != null) {
      return Center(
        child: Text(
          routineState.error!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (routineState.routines.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 48,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'No routine generated for today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Your study plan and daily activities will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: routineState.routines.length,
      itemBuilder: (context, index) {
        final routine = routineState.routines[index];
        return _RoutineTimelineItem(routine: routine);
      },
    );
  }

  String _weekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Sun';
    }
  }

  String _monthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      default:
        return 'Dec';
    }
  }
}

class _RoutineTimelineItem extends StatelessWidget {
  const _RoutineTimelineItem({required this.routine});

  final DailyRoutineModel routine;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColorForTitle(routine.title);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(width: 2, height: 56, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          routine.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${routine.startTime} - ${routine.endTime}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (routine.description != null &&
                      routine.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      routine.description!,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _accentColorForTitle(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('break')) {
      return Colors.green;
    }
    if (normalized.contains('task')) {
      return Colors.orange;
    }
    return Colors.blueAccent;
  }
}

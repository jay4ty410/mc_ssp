// calendar.dart
//
// A self-contained, production-ready Calendar screen for Flutter.
// Replicates: purple header that curves into a white/dark body, a month
// selector, a 7-column day grid with event-dot indicators and an active
// "selected day" chip, a scrollable event list, a floating action button,
// and a custom bottom navigation bar with an active-tab underline.
//
// ---------------------------------------------------------------------------
// HOW TO WIRE UP THE THEME
// ---------------------------------------------------------------------------
// This file defines an `AppColors` ThemeExtension that carries every hex
// value you supplied. Register it once on your app's ThemeData (light and
// dark) and every widget below will read colors through
// `context.appColors` — no hard-coded hex codes inside the UI itself.
//
//   MaterialApp(
//     theme: ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       scaffoldBackgroundColor: AppColors.light.mainBackground,
//       extensions: const [AppColors.light],
//     ),
//     darkTheme: ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       scaffoldBackgroundColor: AppColors.dark.mainBackground,
//       extensions: const [AppColors.dark],
//     ),
//     themeMode: ThemeMode.system,
//     home: const CalendarScreen(),
//   );
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/home_screen.dart'
    show HomeScreen;
import 'package:mc_ssp/features/profile.dart' show ProfileScreen;
import 'package:mc_ssp/features/task_list.dart' show TaskListScreen;

/// ============================================================================
/// THEME EXTENSION
/// ============================================================================
/// Carries every semantic color used by this screen so the UI never touches
/// a raw hex value directly.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color mainBackground;
  final Color cardBackground;
  final Color secondaryBackground;
  final Color primaryAccent;
  final Color tertiaryAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color disabled;
  final Color divider;

  const AppColors({
    required this.mainBackground,
    required this.cardBackground,
    required this.secondaryBackground,
    required this.primaryAccent,
    required this.tertiaryAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.disabled,
    required this.divider,
  });

  /// Light theme mapping (#F8FAFD / #FFFFFF / #1565FF / #6C63FF / ...)
  static const AppColors light = AppColors(
    mainBackground: Color(0xFFF8FAFD),
    cardBackground: Color(0xFFFFFFFF),
    secondaryBackground: Color(0xFFEEF4FF),
    primaryAccent: Color(0xFF1565FF),
    tertiaryAccent: Color(0xFF6C63FF),
    textPrimary: Color(0xFF1C2434),
    textSecondary: Color(0xFF6C7A92),
    success: Color(0xFF34C759),
    warning: Color(0xFFFFC542),
    disabled: Color(0xFFA9B4C5),
    divider: Color(0xFFEAEEF6),
  );

  /// Dark theme mapping (#0B1228 / #18233D / #2E7DFF / #8B7CFF / ...)
  static const AppColors dark = AppColors(
    mainBackground: Color(0xFF0B1228),
    cardBackground: Color(0xFF18233D),
    secondaryBackground: Color(0xFF121A2E),
    primaryAccent: Color(0xFF2E7DFF),
    tertiaryAccent: Color(0xFF8B7CFF),
    textPrimary: Color(0xFFF5F7FA),
    textSecondary: Color(0xFFB7C3D7),
    success: Color(0xFF34C759),
    warning: Color(0xFFFFC542),
    disabled: Color(0xFF3A4560),
    divider: Color(0xFF232F4C),
  );

  @override
  AppColors copyWith({
    Color? mainBackground,
    Color? cardBackground,
    Color? secondaryBackground,
    Color? primaryAccent,
    Color? tertiaryAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? disabled,
    Color? divider,
  }) {
    return AppColors(
      mainBackground: mainBackground ?? this.mainBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      tertiaryAccent: tertiaryAccent ?? this.tertiaryAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      disabled: disabled ?? this.disabled,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      mainBackground: Color.lerp(mainBackground, other.mainBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      secondaryBackground: Color.lerp(
        secondaryBackground,
        other.secondaryBackground,
        t,
      )!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      tertiaryAccent: Color.lerp(tertiaryAccent, other.tertiaryAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

/// Convenience accessor: `context.appColors.primaryAccent`
extension AppColorsX on BuildContext {
  AppColors get appColors {
    return Theme.of(this).extension<AppColors>() ?? AppColors.light;
  }
}

/// ============================================================================
/// DOMAIN MODELS
/// ============================================================================

/// Category drives the leading icon + tint color of an event card.
enum EventCategory { study, health, work }

class CalendarEvent {
  final String title;
  final TimeOfDay start;
  final TimeOfDay end;
  final EventCategory category;

  const CalendarEvent({
    required this.title,
    required this.start,
    required this.end,
    required this.category,
  });

  String get timeRangeLabel => '${_formatTime(start)} – ${_formatTime(end)}';

  static String _formatTime(TimeOfDay t) {
    final hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }
}

/// Maps a category to its label, icon, and semantic tint color.
class _CategoryStyle {
  final String label;
  final IconData icon;
  final Color Function(AppColors colors) tint;

  const _CategoryStyle({
    required this.label,
    required this.icon,
    required this.tint,
  });

  static const Map<EventCategory, _CategoryStyle> byCategory = {
    EventCategory.study: _CategoryStyle(
      label: 'Study',
      icon: Icons.menu_book_rounded,
      tint: _tertiary,
    ),
    EventCategory.health: _CategoryStyle(
      label: 'Health',
      icon: Icons.fitness_center_rounded,
      tint: _success,
    ),
    EventCategory.work: _CategoryStyle(
      label: 'Work',
      icon: Icons.assignment_rounded,
      tint: _warning,
    ),
  };

  static Color _tertiary(AppColors c) => c.tertiaryAccent;
  static Color _success(AppColors c) => c.success;
  static Color _warning(AppColors c) => c.warning;
}

/// ============================================================================
/// CALENDAR SCREEN
/// ============================================================================
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  /// Keyed by 'yyyy-M-d'. Replace with a real data source in production.
  late final Map<String, List<CalendarEvent>> _eventsByDay;

  static const List<String> _weekdayLabels = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2025, 5, 21);
    _focusedMonth = DateTime(2025, 5, 1);
    _eventsByDay = _buildSampleEvents();
  }

  String _keyFor(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Map<String, List<CalendarEvent>> _buildSampleEvents() {
    final data = <String, List<CalendarEvent>>{};

    // Days in May 2025 that carry an event dot in the reference design.
    const dotDays = [1, 5, 7, 10, 11, 13, 16, 18, 21, 22, 24, 25, 27, 29, 31];
    for (final day in dotDays) {
      data[_keyFor(DateTime(2025, 5, day))] = [
        CalendarEvent(
          title: 'Event',
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 10, minute: 0),
          category: EventCategory.work,
        ),
      ];
    }

    // The selected day gets the full, specific agenda from the design.
    data[_keyFor(DateTime(2025, 5, 21))] = [
      const CalendarEvent(
        title: 'Math Study Session',
        start: TimeOfDay(hour: 10, minute: 0),
        end: TimeOfDay(hour: 11, minute: 30),
        category: EventCategory.study,
      ),
      const CalendarEvent(
        title: 'Gym Workout',
        start: TimeOfDay(hour: 17, minute: 0),
        end: TimeOfDay(hour: 18, minute: 0),
        category: EventCategory.health,
      ),
      const CalendarEvent(
        title: 'Project Planning',
        start: TimeOfDay(hour: 19, minute: 0),
        end: TimeOfDay(hour: 20, minute: 0),
        category: EventCategory.work,
      ),
    ];

    return data;
  }

  List<CalendarEvent> get _selectedDayEvents =>
      _eventsByDay[_keyFor(_selectedDate)] ?? const [];

  bool _hasEvents(DateTime day) =>
      (_eventsByDay[_keyFor(day)] ?? const []).isNotEmpty;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Builds a Sunday-first grid covering the full visible month, padded
  /// with the trailing days of the previous month and the leading days of
  /// the next month so every row has exactly 7 cells.
  List<DateTime> _generateGridDays(DateTime month) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // DateTime.weekday: Mon=1 ... Sun=7. Convert so Sunday = 0 offset.
    final leadingOffset = firstOfMonth.weekday % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingOffset));

    final totalCells = ((leadingOffset + daysInMonth) / 7).ceil() * 7;

    return List.generate(totalCells, (i) => gridStart.add(Duration(days: i)));
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime day) {
    setState(() {
      _selectedDate = day;
      if (day.month != _focusedMonth.month || day.year != _focusedMonth.year) {
        _focusedMonth = DateTime(day.year, day.month, 1);
      }
    });
  }

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get _focusedMonthLabel =>
      '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}';

  String get _selectedDateLabel =>
      '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.primaryAccent,
      floatingActionButton: _AddEventFab(colors: colors),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _navigateToTab(context, index),
        onCenterTap: () => _showQuickAddModal(context),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(colors: colors),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.mainBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MonthSelector(
                                label: _focusedMonthLabel,
                                colors: colors,
                                onPrevious: _goToPreviousMonth,
                                onNext: _goToNextMonth,
                              ),
                              const SizedBox(height: 16),
                              _WeekdayRow(
                                labels: _weekdayLabels,
                                colors: colors,
                              ),
                              const SizedBox(height: 4),
                              _CalendarGrid(
                                days: _generateGridDays(_focusedMonth),
                                focusedMonth: _focusedMonth,
                                selectedDate: _selectedDate,
                                colors: colors,
                                hasEvents: _hasEvents,
                                isSameDay: _isSameDay,
                                onSelectDay: _selectDate,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Events on $_selectedDateLabel',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedDayEvents.isEmpty)
                        SliverToBoxAdapter(
                          child: _EmptyEventsState(colors: colors),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverList.separated(
                            itemCount: _selectedDayEvents.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _EventCard(
                                event: _selectedDayEvents[index],
                                colors: colors,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 1) return;

    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      2 => const TaskListScreen(),
      3 => const ProfileScreen(),
      _ => const CalendarScreen(),
    };

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _showQuickAddModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: _QuickAddOption(
                    icon: Icons.event_rounded,
                    label: 'Event',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAddOption(
                    icon: Icons.check_circle_rounded,
                    label: 'Task',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ============================================================================
/// HEADER
/// ============================================================================
class _Header extends StatelessWidget {
  final AppColors colors;
  const _Header({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/register01.png', height: 80),
          Material(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.edit_calendar_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// MONTH SELECTOR
/// ============================================================================
class _MonthSelector extends StatelessWidget {
  final String label;
  final AppColors colors;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.label,
    required this.colors,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavCircleButton(
          icon: Icons.chevron_left_rounded,
          colors: colors,
          onTap: onPrevious,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        _NavCircleButton(
          icon: Icons.chevron_right_rounded,
          colors: colors,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _NavCircleButton extends StatelessWidget {
  final IconData icon;
  final AppColors colors;
  final VoidCallback onTap;

  const _NavCircleButton({
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.secondaryBackground,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: colors.primaryAccent, size: 24),
        ),
      ),
    );
  }
}

/// ============================================================================
/// WEEKDAY ROW
/// ============================================================================
class _WeekdayRow extends StatelessWidget {
  final List<String> labels;
  final AppColors colors;

  const _WeekdayRow({required this.labels, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// ============================================================================
/// CALENDAR GRID
/// ============================================================================
class _CalendarGrid extends StatelessWidget {
  final List<DateTime> days;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final AppColors colors;
  final bool Function(DateTime) hasEvents;
  final bool Function(DateTime, DateTime) isSameDay;
  final ValueChanged<DateTime> onSelectDay;

  const _CalendarGrid({
    required this.days,
    required this.focusedMonth,
    required this.selectedDate,
    required this.colors,
    required this.hasEvents,
    required this.isSameDay,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / 7;
        final rowCount = (days.length / 7).ceil();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 0,
          ),
          itemCount: rowCount * 7,
          itemBuilder: (context, index) {
            final day = days[index];
            final inFocusedMonth =
                day.month == focusedMonth.month &&
                day.year == focusedMonth.year;
            final isSelected = isSameDay(day, selectedDate);
            final showDot = hasEvents(day);

            return _DayCell(
              day: day,
              cellSize: cellSize,
              inFocusedMonth: inFocusedMonth,
              isSelected: isSelected,
              showDot: showDot,
              colors: colors,
              onTap: () => onSelectDay(day),
            );
          },
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final double cellSize;
  final bool inFocusedMonth;
  final bool isSelected;
  final bool showDot;
  final AppColors colors;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.cellSize,
    required this.inFocusedMonth,
    required this.isSelected,
    required this.showDot,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberColor = isSelected
        ? Colors.white
        : (inFocusedMonth ? colors.textPrimary : colors.disabled);

    final dotColor = isSelected
        ? Colors.white
        : (inFocusedMonth ? colors.primaryAccent : colors.disabled);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? colors.primaryAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: numberColor,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 6,
                  width: 6,
                  child: showDot
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// EVENT CARD
/// ============================================================================
class _EventCard extends StatelessWidget {
  final CalendarEvent event;
  final AppColors colors;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _CategoryStyle.byCategory[event.category]!;
    final tint = style.tint(colors);

    return Material(
      color: colors.cardBackground,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.divider),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(style.icon, color: tint, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.timeRangeLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: tint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          style.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyEventsState extends StatelessWidget {
  final AppColors colors;
  const _EmptyEventsState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.divider),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.event_available_rounded,
              color: colors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'No events for this day',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// FLOATING ACTION BUTTON
/// ============================================================================
class _AddEventFab extends StatelessWidget {
  final AppColors colors;
  const _AddEventFab({required this.colors});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: colors.primaryAccent,
      foregroundColor: Colors.white,
      onPressed: () {},
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }
}

class _QuickAddOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAddOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.secondaryBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colors.primaryAccent, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: colors.primaryAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

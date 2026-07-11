import 'package:flutter/material.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/home_screen.dart'
    show HomeScreen;
import 'package:mc_ssp/features/calendar.dart' show CalendarScreen;
import 'package:mc_ssp/features/profile.dart' show ProfileScreen;
import 'package:mc_ssp/features/task_list.dart' show TaskListScreen;

// TODO: Replace with the shared theme import from the main app.
// import 'app_theme.dart';
// TODO: Replace with the shared bottom navigation bar import from the main app.
// import 'app_bottom_navigation_bar.dart';

/// ---------------------------------------------------------------------------
/// RoutineScreen
/// ---------------------------------------------------------------------------
/// Displays the user's full daily routine: header, summary stat cards,
/// filter tabs, a vertical timeline of the day's sessions/tasks/events, and
/// a "Today's Progress" summary card.
///
/// Integration points (state management, navigation, persistence, live data)
/// are marked with `// TODO`. This file is self-contained and includes a
/// local `_Palette` fallback + `main()` so it can be previewed in isolation.
/// ---------------------------------------------------------------------------
class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  RoutineFilter _selectedFilter = RoutineFilter.all;

  final int _bottomNavIndex = 3;

  final DateTime _selectedDate = DateTime(2025, 5, 21);

  static const List<_RoutineItemData> _allItems = [
    _RoutineItemData(
      time: '07:00 AM',
      title: 'Study: Mathematics',
      subtitle: 'Focus Session',
      duration: '50m',
      category: RoutineCategory.study,
    ),
    _RoutineItemData(
      time: '07:50 AM',
      title: 'Short Break',
      subtitle: 'Relax & Recharge',
      duration: '10m',
      category: RoutineCategory.breakTime,
    ),
    _RoutineItemData(
      time: '08:00 AM',
      title: 'Study: Programming',
      subtitle: 'Focus Session',
      duration: '50m',
      category: RoutineCategory.studyAlt,
    ),
    _RoutineItemData(
      time: '08:50 AM',
      title: 'Short Break',
      subtitle: 'Relax & Recharge',
      duration: '10m',
      category: RoutineCategory.breakTime,
    ),
    _RoutineItemData(
      time: '09:00 AM',
      title: 'Data Structures Lecture',
      subtitle: 'Room 305, CS Building',
      duration: '1h',
      category: RoutineCategory.event,
      hasLocationIcon: true,
    ),
    _RoutineItemData(
      time: '10:00 AM',
      title: 'Assignment Submission',
      subtitle: 'Operating Systems',
      duration: '30m',
      category: RoutineCategory.task,
    ),
    _RoutineItemData(
      time: '10:30 AM',
      title: 'Gym Session',
      subtitle: 'FitLife Gym',
      duration: '1h',
      category: RoutineCategory.gym,
    ),
    _RoutineItemData(
      time: '12:00 PM',
      title: 'Lunch Break',
      subtitle: 'Take a healthy break',
      duration: '1h',
      category: RoutineCategory.meal,
    ),
    _RoutineItemData(
      time: '01:00 AM',
      title: 'Study: Database Systems',
      subtitle: 'Focus Session',
      duration: '50m',
      category: RoutineCategory.study,
    ),
    _RoutineItemData(
      time: '01:50 PM',
      title: 'Short Break',
      subtitle: 'Relax & Recharge',
      duration: '10m',
      category: RoutineCategory.breakTime,
    ),
    _RoutineItemData(
      time: '02:00 PM',
      title: 'Study: Computer Networks',
      subtitle: 'Focus Session',
      duration: '50m',
      category: RoutineCategory.studyAlt,
    ),
  ];

  List<_RoutineItemData> get _filteredItems {
    if (_selectedFilter == RoutineFilter.all) return _allItems;
    return _allItems
        .where((item) => item.category.filter == _selectedFilter)
        .toList();
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 3) return;

    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      1 => const CalendarScreen(),
      2 => const TaskListScreen(),
      4 => const ProfileScreen(),
      _ => const RoutineScreen(),
    };

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Scaffold(
      backgroundColor: palette.mainBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),
                  _AppHeader(palette: palette),
                  const SizedBox(height: 24),
                  _RoutineTitleRow(
                    palette: palette,
                    selectedDate: _selectedDate,
                  ),
                  const SizedBox(height: 20),
                  _SummaryCardsRow(palette: palette),
                  const SizedBox(height: 20),
                  _FilterTabsRow(
                    palette: palette,
                    selected: _selectedFilter,
                    onSelected: (filter) {
                      setState(() => _selectedFilter = filter);
                      // TODO: Persist / sync filter selection if needed.
                    },
                  ),
                  const SizedBox(height: 20),
                  _TimelineCard(palette: palette, items: _filteredItems),
                  const SizedBox(height: 20),
                  _TodaysProgressCard(
                    palette: palette,
                    percent: 0.72,
                    completedLabel: '8 of 11 completed',
                    userFirstName: 'Alex',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            AppBottomNavigationBar(
              currentIndex: _bottomNavIndex,
              onTap: (index) => _navigateToTab(context, index),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 1. App Header
// =============================================================================

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.palette});

  final _AppColorsLike palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/register01.png',
          height: 80,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        _NotificationBellIcon(palette: palette, badgeCount: 3),
        const SizedBox(width: 10),
        _ProfileAvatarIcon(palette: palette),
      ],
    );
  }
}

/// Placeholder logo mark: shield + clock/calendar + compass rose motif.
/// Swap for the real asset (e.g. `assets/logo.png`) when available.
class _AppLogoMark extends StatelessWidget {
  const _AppLogoMark({required this.palette});

  final _AppColorsLike palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: palette.primaryBlue.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.shield_moon_outlined,
        color: palette.primaryBlue,
        size: 22,
      ),
      // TODO: Replace with `Image.asset('assets/logo.png')` per design guide.
    );
  }
}

class _NotificationBellIcon extends StatelessWidget {
  const _NotificationBellIcon({
    required this.palette,
    required this.badgeCount,
  });

  final _AppColorsLike palette;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: palette.cardBackground,
            shape: BoxShape.circle,
            boxShadow: palette.softShadow,
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: palette.primaryText,
            size: 20,
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileAvatarIcon extends StatelessWidget {
  const _ProfileAvatarIcon({required this.palette});

  final _AppColorsLike palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: palette.cardBackground,
        shape: BoxShape.circle,
        boxShadow: palette.softShadow,
      ),
      child: Icon(
        Icons.person_outline_rounded,
        color: palette.secondaryText,
        size: 22,
      ),
      // TODO: Replace with actual user avatar image / CircleAvatar(backgroundImage:).
    );
  }
}

// =============================================================================
// 2. Routine Title & Date
// =============================================================================

class _RoutineTitleRow extends StatelessWidget {
  const _RoutineTitleRow({required this.palette, required this.selectedDate});

  final _AppColorsLike palette;
  final DateTime selectedDate;

  static const _months = [
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

  String get _formattedDate =>
      '${_months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Routine',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: palette.primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your complete plan for today',
                style: TextStyle(fontSize: 13, color: palette.secondaryText),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _DateSelectorChip(palette: palette, label: _formattedDate),
      ],
    );
  }
}

class _DateSelectorChip extends StatelessWidget {
  const _DateSelectorChip({required this.palette, required this.label});

  final _AppColorsLike palette;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // TODO: Open a date picker and update selected date.
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: palette.primaryBlue.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: palette.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: palette.primaryBlue,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: palette.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 3. Summary Cards
// =============================================================================

class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow({required this.palette});

  final _AppColorsLike palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: palette.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SummaryCard(
            icon: Icons.calendar_month_rounded,
            count: '6',
            label: 'Sessions',
            color: palette.primaryBlue,
          ),
          _SummaryCard(
            icon: Icons.check_circle_rounded,
            count: '3',
            label: 'Tasks',
            color: const Color(0xFF2FAE6B),
          ),
          _SummaryCard(
            icon: Icons.access_time_filled_rounded,
            count: '2',
            label: 'Events',
            color: const Color(0xFFF2A93B),
          ),
          _SummaryCard(
            icon: Icons.flag_rounded,
            count: '1',
            label: 'Reminders',
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// =============================================================================
// 4. Filter Tabs
// =============================================================================

enum RoutineFilter { all, study, tasks, events, breaks, reminders }

extension _RoutineFilterMeta on RoutineFilter {
  String get label {
    switch (this) {
      case RoutineFilter.all:
        return 'All';
      case RoutineFilter.study:
        return 'Study';
      case RoutineFilter.tasks:
        return 'Tasks';
      case RoutineFilter.events:
        return 'Events';
      case RoutineFilter.breaks:
        return 'Breaks';
      case RoutineFilter.reminders:
        return 'Reminders';
    }
  }

  IconData get icon {
    switch (this) {
      case RoutineFilter.all:
        return Icons.list_alt_rounded;
      case RoutineFilter.study:
        return Icons.school_outlined;
      case RoutineFilter.tasks:
        return Icons.check_box_outlined;
      case RoutineFilter.events:
        return Icons.event_outlined;
      case RoutineFilter.breaks:
        return Icons.free_breakfast_outlined;
      case RoutineFilter.reminders:
        return Icons.notifications_none_rounded;
    }
  }
}

class _FilterTabsRow extends StatelessWidget {
  const _FilterTabsRow({
    required this.palette,
    required this.selected,
    required this.onSelected,
  });

  final _AppColorsLike palette;
  final RoutineFilter selected;
  final ValueChanged<RoutineFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RoutineFilter.values.map((filter) {
          final isSelected = filter == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _FilterChip(
              palette: palette,
              label: filter.label,
              icon: filter.icon,
              selected: isSelected,
              onTap: () => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.palette,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final _AppColorsLike palette;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? palette.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? palette.primaryBlue : palette.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : palette.secondaryText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : palette.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. Vertical Timeline
// =============================================================================

/// Which filter bucket a routine category belongs to.
enum RoutineFilterBucket { study, task, event, breakTime, reminder }

/// Visual category for a timeline item; drives icon, color, and shape.
enum RoutineCategory { study, studyAlt, breakTime, event, task, gym, meal }

extension _RoutineCategoryMeta on RoutineCategory {
  IconData get icon {
    switch (this) {
      case RoutineCategory.study:
      case RoutineCategory.studyAlt:
        return Icons.menu_book_rounded;
      case RoutineCategory.breakTime:
        return Icons.coffee_rounded;
      case RoutineCategory.event:
        return Icons.calendar_today_rounded;
      case RoutineCategory.task:
        return Icons.check_box_rounded;
      case RoutineCategory.gym:
        return Icons.fitness_center_rounded;
      case RoutineCategory.meal:
        return Icons.restaurant_rounded;
    }
  }

  /// `true` for a rounded-square container, `false` for a circle.
  bool get isSquare =>
      this == RoutineCategory.event || this == RoutineCategory.task;

  Color get color {
    switch (this) {
      case RoutineCategory.study:
        return const Color(0xFF3B82F6); // blue
      case RoutineCategory.studyAlt:
        return const Color(0xFF2FAE6B); // green (Programming / Networks)
      case RoutineCategory.breakTime:
        return const Color(0xFF3B82F6); // blue
      case RoutineCategory.event:
        return const Color(0xFFF2A93B); // orange
      case RoutineCategory.task:
        return const Color(0xFF2FAE6B); // green
      case RoutineCategory.gym:
        return const Color(0xFF8B5CF6); // purple
      case RoutineCategory.meal:
        return const Color(0xFFF2A93B); // orange
    }
  }

  RoutineFilter get filter {
    switch (this) {
      case RoutineCategory.study:
      case RoutineCategory.studyAlt:
        return RoutineFilter.study;
      case RoutineCategory.breakTime:
        return RoutineFilter.breaks;
      case RoutineCategory.event:
        return RoutineFilter.events;
      case RoutineCategory.task:
        return RoutineFilter.tasks;
      case RoutineCategory.gym:
        return RoutineFilter.events;
      case RoutineCategory.meal:
        return RoutineFilter.breaks;
    }
  }
}

class _RoutineItemData {
  const _RoutineItemData({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.category,
    this.hasLocationIcon = false,
  });

  final String time;
  final String title;
  final String subtitle;
  final String duration;
  final RoutineCategory category;
  final bool hasLocationIcon;
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.palette, required this.items});

  final _AppColorsLike palette;
  final List<_RoutineItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: palette.softShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return _TimelineItemTile(
            palette: palette,
            item: item,
            isLast: isLast,
          );
        }),
      ),
    );
  }
}

class _TimelineItemTile extends StatelessWidget {
  const _TimelineItemTile({
    required this.palette,
    required this.item,
    required this.isLast,
  });

  final _AppColorsLike palette;
  final _RoutineItemData item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = item.category.color;

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp + dot/line column.
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            // Dot + connecting line.
            Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: palette.divider,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Icon container.
            _CategoryIconBox(category: item.category),
            const SizedBox(width: 14),
            // Title / subtitle.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (item.hasLocationIcon) ...[
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: palette.secondaryText,
                        ),
                        const SizedBox(width: 2),
                      ],
                      Flexible(
                        child: Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.secondaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _DurationChip(color: color, label: item.duration),
          ],
        ),
      ),
    );
  }
}

class _CategoryIconBox extends StatelessWidget {
  const _CategoryIconBox({required this.category});

  final RoutineCategory category;

  @override
  Widget build(BuildContext context) {
    final color = category.color;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: category.isSquare ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: category.isSquare ? BorderRadius.circular(12) : null,
      ),
      child: Icon(category.icon, color: color, size: 18),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// =============================================================================
// 6. Today's Progress Card
// =============================================================================

class _TodaysProgressCard extends StatelessWidget {
  const _TodaysProgressCard({
    required this.palette,
    required this.percent,
    required this.completedLabel,
    required this.userFirstName,
  });

  final _AppColorsLike palette;
  final double percent; // 0.0 - 1.0
  final String completedLabel;
  final String userFirstName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: palette.softShadow,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 6,
                  backgroundColor: palette.divider,
                  valueColor: AlwaysStoppedAnimation(palette.primaryBlue),
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: palette.primaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Progress",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: palette.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  completedLabel,
                  style: TextStyle(fontSize: 12, color: palette.secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep it up, $userFirstName!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: palette.primaryText,
                          ),
                        ),
                        Text(
                          "You're on track to achieve your goals.",
                          style: TextStyle(
                            fontSize: 10,
                            color: palette.secondaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Standalone preview support
// =============================================================================
// TODO: Remove this section once integrated into the main app; use the real
// `AppColorsExt` (`context.appColors`) and shared `AppBottomNavigationBar`
// from `app_theme.dart` / `app_bottom_navigation_bar.dart` instead.

/// Minimal shape mirroring the fields of the shared `AppColorsExt` used by
/// this screen, so the file compiles standalone.
abstract class _AppColorsLike {
  Color get primaryText;
  Color get secondaryText;
  Color get primaryBlue;
  Color get cardBackground;
  Color get mainBackground;
  Color get divider;
  List<BoxShadow> get softShadow;
}

class _Palette implements _AppColorsLike {
  const _Palette();

  @override
  Color get primaryText => const Color(0xFF1A1D29);
  @override
  Color get secondaryText => const Color(0xFF8A8FA3);
  @override
  Color get primaryBlue => const Color(0xFF3B82F6);
  @override
  Color get cardBackground => Colors.white;
  @override
  Color get mainBackground => const Color(0xFFF5F7FB);
  @override
  Color get divider => const Color(0xFFEDEFF5);
  @override
  List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}

/// TODO: Replace this extension with the real `context.appColors` getter
/// from `app_theme.dart`. Kept here only so the file compiles standalone.
extension _StandaloneAppColors on BuildContext {
  _AppColorsLike get appColors => const _Palette();
}

void main() {
  runApp(const _RoutinePreviewApp());
}

class _RoutinePreviewApp extends StatelessWidget {
  const _RoutinePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MC_SS Routine Preview',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const RoutineScreen(),
    );
  }
}

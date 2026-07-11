import 'package:flutter/material.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/home_screen.dart'
    show HomeScreen;
import 'package:mc_ssp/features/authentication/presentation/pages/routine.dart'
    show RoutineScreen;
import 'package:mc_ssp/features/calendar.dart' show CalendarScreen;
import 'package:mc_ssp/features/profile.dart' show ProfileScreen;

/// ----------------------------------------------------------------
/// Data model
/// ----------------------------------------------------------------
enum TaskStatus { inProgress, completed, pending, highPriority }

enum TaskIconType { document, success, meeting, code, warning }

class TaskItem {
  final String title;
  final String dueDate;
  final String location;
  final TaskStatus status;
  final TaskIconType iconType;

  const TaskItem({
    required this.title,
    required this.dueDate,
    required this.location,
    required this.status,
    required this.iconType,
  });
}

/// ----------------------------------------------------------------
/// Mock data — mirrors the reference design
/// ----------------------------------------------------------------
const List<TaskItem> mockTasks = [
  TaskItem(
    title: 'Prepare Monthly Report',
    dueDate: 'Due: May 20, 2024',
    location: 'Office',
    status: TaskStatus.inProgress,
    iconType: TaskIconType.document,
  ),
  TaskItem(
    title: 'Review Project Proposal',
    dueDate: 'Due: May 21, 2024',
    location: 'Conference Room',
    status: TaskStatus.completed,
    iconType: TaskIconType.success,
  ),
  TaskItem(
    title: 'Team Meeting',
    dueDate: 'Due: May 22, 2024',
    location: 'Conference Room',
    status: TaskStatus.pending,
    iconType: TaskIconType.meeting,
  ),
  TaskItem(
    title: 'Code Review',
    dueDate: 'Due: May 24, 2024',
    location: 'Online Meeting',
    status: TaskStatus.inProgress,
    iconType: TaskIconType.code,
  ),
  TaskItem(
    title: 'Fix Login Issue',
    dueDate: 'Due: May 25, 2024',
    location: 'Mobile App',
    status: TaskStatus.highPriority,
    iconType: TaskIconType.warning,
  ),
];

/// ----------------------------------------------------------------
/// Color palette helpers
/// ----------------------------------------------------------------
class AppColors {
  static const navy = Color(0xFF0F172A);
  static const mutedBlue = Color(0xFF64748B);
  static const primaryBlue = Color(0xFF2563EB);
  static const lightBlueBg = Color(0xFFEFF6FF);
  static const cardBorder = Color(0xFFE2E8F0);

  static const successGreen = Color(0xFF16A34A);
  static const successBg = Color(0xFFDCFCE7);

  static const warningOrange = Color(0xFFEA580C);
  static const warningBg = Color(0xFFFFEDD5);

  static const dangerRed = Color(0xFFDC2626);
  static const dangerBg = Color(0xFFFEE2E2);

  static const purple = Color(0xFF7C3AED);
  static const purpleBg = Color(0xFFF3E8FF);
}

/// ----------------------------------------------------------------
/// Main screen
/// ----------------------------------------------------------------
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _filters = [
    'All',
    'In Progress',
    'Completed',
    'Overdue',
  ];

  List<TaskItem> get _filteredTasks {
    final query = _searchController.text.trim().toLowerCase();
    Iterable<TaskItem> result = mockTasks;

    if (_selectedFilter != 'All') {
      final statusMap = {
        'In Progress': TaskStatus.inProgress,
        'Completed': TaskStatus.completed,
        'Overdue': TaskStatus.highPriority,
      };
      final target = statusMap[_selectedFilter];
      if (target != null) {
        result = result.where((t) => t.status == target);
      }
    }

    if (query.isNotEmpty) {
      result = result.where((t) => t.title.toLowerCase().contains(query));
    }

    return result.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 28),
                    _buildHeadline(),
                    const SizedBox(height: 20),
                    _buildSearchAndFilter(),
                    const SizedBox(height: 16),
                    _buildStatusChips(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final task = _filteredTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TaskCard(task: task),
                  );
                }, childCount: _filteredTasks.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildAddTaskButton()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _navigateToTab(context, index),
        onCenterTap: () => _showQuickAddModal(context),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 2) return;

    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      1 => const CalendarScreen(),
      3 => const RoutineScreen(),
      4 => const ProfileScreen(),
      _ => const TaskListScreen(),
    };

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
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

  // ---------------- Top bar (logo + notifications + avatar) ----------------
  Widget _buildTopBar() {
    return Row(
      children: [
        Image.asset('assets/images/register01.png', height: 80),
        const Spacer(),
        _NotificationBell(count: 3),
        const SizedBox(width: 10),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFF1F5F9),
          child: Icon(Icons.person, color: AppColors.mutedBlue),
        ),
      ],
    );
  }

  Widget _buildHeadline() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Manage and organize your tasks',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.mutedBlue,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 14, color: AppColors.navy),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: const TextStyle(
                  color: AppColors.mutedBlue,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.mutedBlue,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.filter_list, color: AppColors.navy, size: 20),
                SizedBox(width: 6),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          final style = _chipStyleFor(filter, isSelected);

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: style.foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _ChipStyle _chipStyleFor(String filter, bool isSelected) {
    if (isSelected) {
      return const _ChipStyle(
        background: AppColors.primaryBlue,
        foreground: Colors.white,
      );
    }
    switch (filter) {
      case 'In Progress':
        return const _ChipStyle(
          background: AppColors.lightBlueBg,
          foreground: AppColors.primaryBlue,
        );
      case 'Completed':
        return const _ChipStyle(
          background: AppColors.successBg,
          foreground: AppColors.successGreen,
        );
      case 'Overdue':
        return const _ChipStyle(
          background: AppColors.dangerBg,
          foreground: AppColors.dangerRed,
        );
      default:
        return const _ChipStyle(
          background: Color(0xFFF1F5F9),
          foreground: AppColors.mutedBlue,
        );
    }
  }

  Widget _buildAddTaskButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.primaryBlue.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 22),
              SizedBox(width: 8),
              Text(
                'Add Task',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipStyle {
  final Color background;
  final Color foreground;
  const _ChipStyle({required this.background, required this.foreground});
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
    return Material(
      color: AppColors.lightBlueBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 28),
              const SizedBox(height: 8),
              const Text(
                'Quick Add',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.mutedBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------
/// Notification bell with badge
/// ----------------------------------------------------------------
class _NotificationBell extends StatelessWidget {
  final int count;
  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.navy,
            size: 22,
          ),
        ),
        if (count > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
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

/// ----------------------------------------------------------------
/// Task card widget
/// ----------------------------------------------------------------
class TaskCard extends StatelessWidget {
  final TaskItem task;
  const TaskCard({super.key, required this.task});

  _IconStyle get _iconStyle {
    switch (task.iconType) {
      case TaskIconType.document:
        return const _IconStyle(
          background: AppColors.lightBlueBg,
          foreground: AppColors.primaryBlue,
          icon: Icons.description_outlined,
        );
      case TaskIconType.success:
        return const _IconStyle(
          background: AppColors.successBg,
          foreground: AppColors.successGreen,
          icon: Icons.check_circle_outline,
        );
      case TaskIconType.meeting:
        return const _IconStyle(
          background: AppColors.warningBg,
          foreground: AppColors.warningOrange,
          icon: Icons.people_alt_outlined,
        );
      case TaskIconType.code:
        return const _IconStyle(
          background: AppColors.purpleBg,
          foreground: AppColors.purple,
          icon: Icons.code,
        );
      case TaskIconType.warning:
        return const _IconStyle(
          background: AppColors.dangerBg,
          foreground: AppColors.dangerRed,
          icon: Icons.error_outline,
        );
    }
  }

  _StatusStyle get _statusStyle {
    switch (task.status) {
      case TaskStatus.inProgress:
        return const _StatusStyle(
          label: 'In Progress',
          background: AppColors.lightBlueBg,
          foreground: AppColors.primaryBlue,
        );
      case TaskStatus.completed:
        return const _StatusStyle(
          label: 'Completed',
          background: AppColors.successBg,
          foreground: AppColors.successGreen,
        );
      case TaskStatus.pending:
        return const _StatusStyle(
          label: 'Pending',
          background: AppColors.warningBg,
          foreground: AppColors.warningOrange,
        );
      case TaskStatus.highPriority:
        return const _StatusStyle(
          label: 'High Priority',
          background: AppColors.dangerBg,
          foreground: AppColors.dangerRed,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconStyle = _iconStyle;
    final statusStyle = _statusStyle;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconStyle.background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconStyle.icon, color: iconStyle.foreground, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.mutedBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.dueDate,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.mutedBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusStyle.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusStyle.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusStyle.foreground,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.mutedBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconStyle {
  final Color background;
  final Color foreground;
  final IconData icon;
  const _IconStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });
}

class _StatusStyle {
  final String label;
  final Color background;
  final Color foreground;
  const _StatusStyle({
    required this.label,
    required this.background,
    required this.foreground,
  });
}

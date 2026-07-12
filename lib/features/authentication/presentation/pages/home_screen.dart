import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mc_ssp/providers/repository_providers.dart';
import 'package:mc_ssp/providers/firebase_providers.dart';
import 'package:mc_ssp/features/authentication/repositories/user_repository.dart';
import 'package:mc_ssp/features/authentication/models/user_model.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/calendar.dart' show CalendarScreen;
import 'package:mc_ssp/features/profile.dart' show ProfileScreen;
import 'package:mc_ssp/features/task_list.dart' show TaskListScreen;
import 'package:mc_ssp/features/authentication/presentation/pages/routine.dart'
    show RoutineScreen;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildTopBar(ref),
              const SizedBox(height: 20),
              _buildGreetingHeader(ref),
              const SizedBox(height: 20),
              _buildStatsCard(),
              const SizedBox(height: 20),
              _buildScheduleCard(),
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
              const SizedBox(height: 20),
              _buildAiSuggestionsCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _navigateToTab(context, index),
        onCenterTap: () => _showQuickAddModal(context),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 0) return;

    final Widget screen = switch (index) {
      1 => const CalendarScreen(),
      2 => const TaskListScreen(),
      3 => const RoutineScreen(),
      4 => const ProfileScreen(),
      _ => const HomeScreen(),
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

  // ---------------------------------------------------------------------
  // TOP BAR: Logo + Notification Bell + Profile Avatar
  // ---------------------------------------------------------------------
  Widget _buildTopBar(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/register01.png', height: 80),
        Row(
          children: [
            _buildNotificationBell(),
            const SizedBox(width: 12),
            _buildProfileAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.black87,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF2F6BFF),
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person_outline, color: Colors.black54),
    );
  }

  // ---------------------------------------------------------------------
  // GREETING HEADER
  // ---------------------------------------------------------------------
  Widget _buildGreetingHeader(WidgetRef ref) {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good morning, NoBody 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Here's your schedule overview",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          _buildTodayDropdown(),
        ],
      );
    }

    final userFuture = ref.read(userRepositoryProvider).getUser(userId);

    return FutureBuilder<UserModel?>(
      future: userFuture,
      builder: (context, snapshot) {
        final displayName = snapshot.data?.displayName ?? 'NoBody';
        final subtitle =
            snapshot.data?.email ?? "Here's your schedule overview";

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, $displayName 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            _buildTodayDropdown(),
          ],
        );
      },
    );
  }

  Widget _buildTodayDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: Color(0xFF2F6BFF),
          ),
          SizedBox(width: 6),
          Text(
            'Today',
            style: TextStyle(
              color: Color(0xFF2F6BFF),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Color(0xFF2F6BFF),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // OVERVIEW STATS CARD
  // ---------------------------------------------------------------------
  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFF2F6BFF),
            iconBg: const Color(0xFFE4ECFF),
            label: "Today's Events",
            count: '5',
            subtitle: 'Upcoming',
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF2FBF71),
            iconBg: const Color(0xFFDFF6E8),
            label: 'Completed',
            count: '2',
            subtitle: 'Tasks',
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            icon: Icons.access_time_filled_rounded,
            iconColor: const Color(0xFFF5A623),
            iconBg: const Color(0xFFFFF1DA),
            label: 'Pending',
            count: '3',
            subtitle: 'Tasks',
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            icon: Icons.flag_rounded,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFEDE4FF),
            label: 'Overdue',
            count: '1',
            subtitle: 'Task',
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 70, color: const Color(0xFFECECEC));
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String count,
    required String subtitle,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TODAY'S SCHEDULE TIMELINE CARD
  // ---------------------------------------------------------------------
  Widget _buildScheduleCard() {
    final events = [
      _ScheduleEvent(
        time: '09:00 AM',
        timeColor: const Color(0xFF2F6BFF),
        title: 'Team Stand-up',
        category: 'Work',
        location: 'Conference Room',
        duration: '30m',
        icon: Icons.work_outline_rounded,
        iconColor: const Color(0xFF2F6BFF),
        iconBg: const Color(0xFFE4ECFF),
      ),
      _ScheduleEvent(
        time: '10:30 AM',
        timeColor: const Color(0xFF2FBF71),
        title: 'Project Planning',
        category: 'Work',
        location: 'Conference Room',
        duration: '1h',
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF2FBF71),
        iconBg: const Color(0xFFDFF6E8),
      ),
      _ScheduleEvent(
        time: '01:00 PM',
        timeColor: const Color(0xFFF5A623),
        title: 'Lunch Break',
        category: 'Personal',
        location: '—',
        duration: '1h',
        icon: Icons.restaurant_outlined,
        iconColor: const Color(0xFFF5A623),
        iconBg: const Color(0xFFFFF1DA),
      ),
      _ScheduleEvent(
        time: '02:00 PM',
        timeColor: const Color(0xFF8B5CF6),
        title: 'Code Review',
        category: 'Work',
        location: 'Online Meeting',
        duration: '45m',
        icon: Icons.code_rounded,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFEDE4FF),
      ),
      _ScheduleEvent(
        time: '04:00 PM',
        timeColor: const Color(0xFF2F6BFF),
        title: 'Gym Session',
        category: 'Personal',
        location: 'FitLife Gym',
        duration: '1h',
        icon: Icons.fitness_center_rounded,
        iconColor: const Color(0xFF2F6BFF),
        iconBg: const Color(0xFFE4ECFF),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F6BFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(events.length, (index) {
              final isLast = index == events.length - 1;
              return _buildTimelineItem(events[index], isLast: isLast);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_ScheduleEvent event, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp column
          SizedBox(
            width: 66,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                event.time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: event.timeColor,
                ),
              ),
            ),
          ),
          // Timeline line + bullet
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: event.timeColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: const Color(0xFFE0E0E0)),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Icon
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: event.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(event.icon, color: event.iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Title / category / location
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.category,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2F6BFF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Colors.black38,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Duration tag
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.duration,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F6BFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // QUICK ACTIONS
  // ---------------------------------------------------------------------
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                  'Customize',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F6BFF),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.settings_outlined,
                  size: 16,
                  color: Color(0xFF2F6BFF),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildQuickActionCard(
                icon: Icons.add_rounded,
                label: 'Add Event',
                iconColor: const Color(0xFF2F6BFF),
                bgColor: const Color(0xFFE4ECFF),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.check_rounded,
                label: 'Add Task',
                iconColor: const Color(0xFF2FBF71),
                bgColor: const Color(0xFFDFF6E8),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Calendar View',
                iconColor: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFEDE4FF),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.bar_chart_rounded,
                label: 'Analytics',
                iconColor: const Color(0xFFF5A623),
                bgColor: const Color(0xFFFFF1DA),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                icon: Icons.auto_awesome_rounded,
                label: 'AI Suggestions',
                iconColor: const Color(0xFF29B6F6),
                bgColor: const Color(0xFFDFF4FE),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: iconColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // AI SUGGESTIONS BANNER
  // ---------------------------------------------------------------------
  Widget _buildAiSuggestionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: Color(0xFF2F6BFF),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'AI Suggestions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F6BFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4ECFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF2F6BFF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'You have a free gap at 11:45 AM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Would you like to schedule a focus session?',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2F6BFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Schedule',
                  style: TextStyle(
                    color: Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isActive = index == 0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF2F6BFF)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BOTTOM NAVIGATION BAR
  // ---------------------------------------------------------------------

  // ---------------------------------------------------------------------
  // SHARED DECORATION
  // ---------------------------------------------------------------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// SCHEDULE EVENT MODEL
// ---------------------------------------------------------------------
class _ScheduleEvent {
  final String time;
  final Color timeColor;
  final String title;
  final String category;
  final String location;
  final String duration;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  _ScheduleEvent({
    required this.time,
    required this.timeColor,
    required this.title,
    required this.category,
    required this.location,
    required this.duration,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
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
      color: const Color(0xFFEAF1FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF2F6BFF), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF2F6BFF),
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

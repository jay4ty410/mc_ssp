import 'package:flutter/material.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/home_screen.dart'
    show HomeScreen;
import 'package:mc_ssp/features/calendar.dart' show CalendarScreen;
import 'package:mc_ssp/features/task_list.dart' show TaskListScreen;

// Sub-pages reachable from the Profile settings menu. `show` is used so the
// destination files' own `AppColors` classes don't collide with this file's.
import 'package:mc_ssp/features/authentication/presentation/pages/account_info.dart'
    show AccountInfoScreen;
import 'package:mc_ssp/features/authentication/presentation/pages/appearance.dart'
    show AppearanceScreen;
import 'package:mc_ssp/features/authentication/presentation/pages/preferences.dart'
    show PreferencesPage;
import 'package:mc_ssp/features/authentication/presentation/pages/notifications.dart'
    show NotificationsScreen;
import 'package:mc_ssp/features/authentication/presentation/pages/security.dart'
    show SecurityScreen;
// Edit profile screen
import 'package:mc_ssp/features/authentication/presentation/pages/edit_profile.dart'
    show EditProfileScreen;

class AppColors {
  static const Color background = Color(0xFFF5F7FA);
  static const Color navy = Color(0xFF0A192F);
  static const Color mutedGray = Color(0xFF8A94A6);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color dividerGray = Color(0xFFE7EAEF);

  static const Color blue = Color(0xFF2F6FED);
  static const Color blueLight = Color(0xFFE8F0FE);

  static const Color green = Color(0xFF34C77B);
  static const Color greenLight = Color(0xFFE3F8ED);

  static const Color orange = Color(0xFFF5A623);
  static const Color orangeLight = Color(0xFFFDF1DE);

  static const Color purple = Color(0xFF7C5CFC);
  static const Color purpleLight = Color(0xFFEFEAFF);

  static const Color darkBlue = Color(0xFF1D3A8F);
  static const Color darkBlueLight = Color(0xFFE7ECFB);

  static const Color deepPurple = Color(0xFF5B3FBF);
  static const Color deepPurpleLight = Color(0xFFEDE8FB);

  static const Color red = Color(0xFFE0554F);
  static const Color redLight = Color(0xFFFBEAEA);
}

/// ---------------------------------------------------------------------------
/// Profile Screen
/// ---------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildTitleSection(),
              const SizedBox(height: 20),
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildSettingsCard(),
              const SizedBox(height: 20),
              _buildLogoutButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) => _navigateToTab(context, index),
        onCenterTap: () => _showQuickAddModal(context),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 3) return;

    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      1 => const CalendarScreen(),
      2 => const TaskListScreen(),
      _ => const ProfileScreen(),
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
  // 2. Top App Bar / Header Section
  // ---------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/register01.png',
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            // Fallback placeholder in case the asset is not yet bundled.
            return Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.event_note, color: AppColors.blue),
            );
          },
        ),
        Row(
          children: [
            _buildNotificationBell(),
            const SizedBox(width: 10),
            _buildAvatarIcon(),
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
          height: 44,
          width: 44,
          decoration: const BoxDecoration(
            color: AppColors.cardWhite,
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
            color: AppColors.navy,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: const Text(
              '3',
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget _buildAvatarIcon() {
    return Container(
      height: 44,
      width: 44,
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: AppColors.navy),
    );
  }

  // ---------------------------------------------------------------------
  // 3. Title Section
  // ---------------------------------------------------------------------
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your account and preferences',
          style: TextStyle(fontSize: 14, color: AppColors.mutedGray),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // 4. User Profile Card
  // ---------------------------------------------------------------------
  Widget _buildProfileCard() {
    return _WhiteCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarWithCameraBadge(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Johnson',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'alex.johnson@mcss.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRoleBadge(),
                  ],
                ),
              ),
              _buildEditButton(),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.dividerGray),
          const SizedBox(height: 16),
          _buildTaskAnalyticsGrid(),
        ],
      ),
    );
  }

  Widget _buildAvatarWithCameraBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundColor: AppColors.blueLight,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardWhite, width: 2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Team Member',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.blue,
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
      },
      icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.blue),
      label: Text(
        'Edit',
        style: TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.blueLight,
        side: BorderSide(color: AppColors.blue.withValues(alpha: 0.35)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTaskAnalyticsGrid() {
    final stats = [
      _TaskStat(
        icon: Icons.calendar_today_rounded,
        iconColor: AppColors.blue,
        iconBackground: AppColors.blueLight,
        value: '24',
        label: 'Tasks\nAssigned',
      ),
      _TaskStat(
        icon: Icons.check_rounded,
        iconColor: AppColors.green,
        iconBackground: AppColors.greenLight,
        value: '16',
        label: 'Tasks\nCompleted',
      ),
      _TaskStat(
        icon: Icons.access_time_rounded,
        iconColor: AppColors.orange,
        iconBackground: AppColors.orangeLight,
        value: '5',
        label: 'Tasks\nPending',
      ),
      _TaskStat(
        icon: Icons.flag_rounded,
        iconColor: AppColors.purple,
        iconBackground: AppColors.purpleLight,
        value: '3',
        label: 'Overdue\nTasks',
      ),
    ];

    return Row(
      children: List.generate(stats.length, (index) {
        final stat = stats[index];
        return Expanded(
          child: Row(
            children: [
              if (index != 0)
                Container(
                  width: 1,
                  height: 54,
                  color: AppColors.dividerGray,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
              Expanded(child: _TaskStatColumn(stat: stat)),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------
  // 5. Settings Menu Options
  // ---------------------------------------------------------------------
  Widget _buildSettingsCard() {
    final items = [
      _SettingsItemData(
        icon: Icons.person_outline,
        iconColor: AppColors.blue,
        iconBackground: AppColors.blueLight,
        title: 'Account Information',
        subtitle: 'View and update your personal details',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AccountInfoScreen())),
      ),
      _SettingsItemData(
        icon: Icons.settings_outlined,
        iconColor: AppColors.darkBlue,
        iconBackground: AppColors.darkBlueLight,
        title: 'Preferences',
        subtitle: 'Customize your app experience',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PreferencesPage())),
      ),
      _SettingsItemData(
        icon: Icons.notifications_none_rounded,
        iconColor: AppColors.purple,
        iconBackground: AppColors.purpleLight,
        title: 'Notifications',
        subtitle: 'Manage your notification settings',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
      ),
      _SettingsItemData(
        icon: Icons.shield_outlined,
        iconColor: AppColors.green,
        iconBackground: AppColors.greenLight,
        title: 'Security',
        subtitle: 'Change password and security options',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SecurityScreen())),
      ),
      _SettingsItemData(
        icon: Icons.dark_mode_outlined,
        iconColor: AppColors.deepPurple,
        iconBackground: AppColors.deepPurpleLight,
        title: 'Appearance',
        subtitle: 'Choose theme and display options',
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AppearanceScreen())),
      ),
      _SettingsItemData(
        icon: Icons.help_outline_rounded,
        iconColor: AppColors.blue,
        iconBackground: AppColors.blueLight,
        title: 'Help & Support',
        subtitle: 'Get help and contact support',
      ),
      _SettingsItemData(
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.blue,
        iconBackground: AppColors.blueLight,
        title: 'About MCSS',
        subtitle: 'App version and information',
      ),
    ];

    return _WhiteCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: List.generate(items.length, (index) {
          final isLast = index == items.length - 1;
          return Column(
            children: [
              _SettingsMenuTile(data: items[index]),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: AppColors.dividerGray),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // 6. Action Button
  // ---------------------------------------------------------------------
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Hook up sign-out logic.
        },
        icon: const Icon(Icons.logout, color: AppColors.red, size: 18),
        label: Text(
          'Log Out',
          style: TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.cardWhite,
          side: BorderSide(color: AppColors.red.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Reusable Widgets
/// ---------------------------------------------------------------------------

/// A generic rounded, softly-shadowed white card used throughout the screen.
class _WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _WhiteCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
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
    return Material(
      color: AppColors.blueLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.blue, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.blue,
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

/// Data model for a single task-analytics stat (icon, value, label).
class _TaskStat {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;

  const _TaskStat({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
  });
}

/// A single column within the task-analytics grid.
class _TaskStatColumn extends StatelessWidget {
  final _TaskStat stat;

  const _TaskStatColumn({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: stat.iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(stat.icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          stat.value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.mutedGray,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

/// Data model for a single settings menu row.
class _SettingsItemData {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsItemData({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

/// A single row within the settings menu card.
class _SettingsMenuTile extends StatelessWidget {
  final _SettingsItemData data;

  const _SettingsMenuTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: data.iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.mutedGray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.mutedGray),
          ],
        ),
      ),
    );
  }
}

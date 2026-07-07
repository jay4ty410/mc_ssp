import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// MC_SS Smart Scheduler — Notifications Settings Screen
/// -----------------------------------------------------------------------
/// Replicates the "Notifications" preferences UI using the app's design
/// system (see MC_SS_Color_Palette_and_Theme_Guide).
/// -----------------------------------------------------------------------
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // ---------------------------------------------------------------------
  // Theme Colors
  // ---------------------------------------------------------------------
  static const Color kBackground = Color(0xFFF8FAFD);
  static const Color kCardBackground = Color(0xFFFFFFFF);
  static const Color kPrimaryText = Color(0xFF1C2434);
  static const Color kSecondaryText = Color(0xFF6C7A92);
  static const Color kPrimaryBlue = Color(0xFF1565FF);
  static const Color kDivider = Color(0xFFE8EDF5);
  static const Color kSuccess = Color(0xFF34C759);
  static const Color kWarning = Color(0xFFFFC542);
  static const Color kError = Color(0xFFFF5A5F);
  static const Color kInfo = Color(0xFF4A90E2);
  static const Color kAiAccent = Color(0xFF6C63FF); // purple accent

  // ---------------------------------------------------------------------
  // State — Notification Preferences
  // ---------------------------------------------------------------------
  bool _taskAssignments = true;
  bool _taskUpdates = true;
  bool _taskReminders = true;
  bool _overdueAlerts = true;
  bool _messages = true;
  bool _teamUpdates = false;

  // State — Quiet Hours / Do Not Disturb
  bool _quietHoursEnabled = false;
  bool _doNotDisturbOn = false;

  final String _userEmail = 'alex.johnson@mcss.com';
  final String _quietFrom = '10:00 PM';
  final String _quietTo = '7:00 AM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPreferencesCard(),
              const SizedBox(height: 20),
              _buildMethodsCard(),
              const SizedBox(height: 20),
              _buildQuietHoursCard(),
              const SizedBox(height: 20),
              _buildDoNotDisturbCard(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // =======================================================================
  // HEADER
  // =======================================================================
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).maybePop(),
          child: const Padding(
            padding: EdgeInsets.only(top: 4, right: 12),
            child: Icon(Icons.arrow_back, color: kPrimaryText, size: 24),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your notification preferences',
                style: TextStyle(fontSize: 13, color: kSecondaryText),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: kAiAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: kAiAccent,
            size: 22,
          ),
        ),
      ],
    );
  }

  // =======================================================================
  // SECTION 1 — NOTIFICATION PREFERENCES
  // =======================================================================
  Widget _buildPreferencesCard() {
    return _buildSectionCard(
      headerIcon: Icons.notifications_active_rounded,
      headerIconColor: kAiAccent,
      headerIconBg: kAiAccent.withOpacity(0.12),
      title: 'Notification Preferences',
      subtitle: 'Choose what notifications you want to receive',
      children: [
        _buildSwitchRow(
          icon: Icons.assignment_outlined,
          iconColor: kPrimaryBlue,
          iconBg: kPrimaryBlue.withOpacity(0.10),
          title: 'Task Assignments',
          subtitle: 'When you\'re assigned a new task',
          value: _taskAssignments,
          onChanged: (v) => setState(() => _taskAssignments = v),
        ),
        _divider(),
        _buildSwitchRow(
          icon: Icons.update_rounded,
          iconColor: kSuccess,
          iconBg: kSuccess.withOpacity(0.10),
          title: 'Task Updates',
          subtitle: 'When a task status changes',
          value: _taskUpdates,
          onChanged: (v) => setState(() => _taskUpdates = v),
        ),
        _divider(),
        _buildSwitchRow(
          icon: Icons.alarm_rounded,
          iconColor: kWarning,
          iconBg: kWarning.withOpacity(0.16),
          title: 'Task Reminders',
          subtitle: 'Reminders before deadlines',
          value: _taskReminders,
          onChanged: (v) => setState(() => _taskReminders = v),
        ),
        _divider(),
        _buildSwitchRow(
          icon: Icons.error_outline_rounded,
          iconColor: kAiAccent,
          iconBg: kAiAccent.withOpacity(0.12),
          title: 'Overdue Alerts',
          subtitle: 'When a task passes its due date',
          value: _overdueAlerts,
          onChanged: (v) => setState(() => _overdueAlerts = v),
        ),
        _divider(),
        _buildSwitchRow(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: kInfo,
          iconBg: kInfo.withOpacity(0.10),
          title: 'Messages',
          subtitle: 'New direct messages and replies',
          value: _messages,
          onChanged: (v) => setState(() => _messages = v),
        ),
        _divider(),
        _buildSwitchRow(
          icon: Icons.groups_outlined,
          iconColor: kAiAccent,
          iconBg: kAiAccent.withOpacity(0.12),
          title: 'Team Updates',
          subtitle: 'Announcements from your team',
          value: _teamUpdates,
          onChanged: (v) => setState(() => _teamUpdates = v),
        ),
      ],
    );
  }

  // =======================================================================
  // SECTION 2 — NOTIFICATION METHODS
  // =======================================================================
  Widget _buildMethodsCard() {
    return _buildSectionCard(
      title: 'Notification Methods',
      subtitle: 'Choose how you want to receive notifications',
      showHeaderIcon: false,
      children: [
        _buildNavigationRow(
          icon: Icons.email_outlined,
          iconColor: kPrimaryBlue,
          iconBg: kPrimaryBlue.withOpacity(0.10),
          title: 'Email Notifications',
          trailingText: _userEmail,
          onTap: () {},
        ),
        _divider(),
        _buildNavigationRow(
          icon: Icons.phone_iphone_rounded,
          iconColor: kSuccess,
          iconBg: kSuccess.withOpacity(0.10),
          title: 'Push Notifications',
          onTap: () {},
        ),
      ],
    );
  }

  // =======================================================================
  // SECTION 3 — QUIET HOURS
  // =======================================================================
  Widget _buildQuietHoursCard() {
    return _buildSectionCard(
      title: 'Quiet Hours',
      subtitle: 'Set times when you don\'t want to receive notifications',
      showHeaderIcon: false,
      children: [
        _buildSwitchRow(
          icon: Icons.dark_mode_outlined,
          iconColor: kAiAccent,
          iconBg: kAiAccent.withOpacity(0.12),
          title: 'Quiet Hours',
          subtitle: 'Pause non-urgent notifications',
          value: _quietHoursEnabled,
          onChanged: (v) => setState(() => _quietHoursEnabled = v),
        ),
        _divider(),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(fontSize: 12, color: kSecondaryText),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _quietFrom,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: kDivider,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(fontSize: 12, color: kSecondaryText),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _quietTo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: kSecondaryText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =======================================================================
  // SECTION 4 — DO NOT DISTURB
  // =======================================================================
  Widget _buildDoNotDisturbCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Do Not Disturb',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pause all notifications temporarily',
                  style: TextStyle(fontSize: 13, color: kSecondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () => setState(() => _doNotDisturbOn = !_doNotDisturbOn),
            style: OutlinedButton.styleFrom(
              foregroundColor: kError,
              side: const BorderSide(color: kError, width: 1.4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              _doNotDisturbOn ? 'Turn Off' : 'Turn On',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // REUSABLE BUILDERS
  // =======================================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: kCardBackground,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: kPrimaryText.withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 1, color: kDivider);
  }

  /// Wraps a section header + list of rows into a single white card.
  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
    IconData? headerIcon,
    Color? headerIconColor,
    Color? headerIconBg,
    bool showHeaderIcon = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeaderIcon && headerIcon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: headerIconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(headerIcon, color: headerIconColor, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12.5, color: kSecondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  /// A row with a leading icon container, title/subtitle, and a Switch.
  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildIconContainer(icon, iconColor, iconBg),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.5, color: kSecondaryText),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: kPrimaryBlue,
          ),
        ],
      ),
    );
  }

  /// A row with a leading icon container, a title, and either a trailing
  /// text value or just a chevron — tappable for navigation.
  Widget _buildNavigationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _buildIconContainer(icon, iconColor, iconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryText,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(fontSize: 13, color: kSecondaryText),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right_rounded, color: kSecondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color, Color bg) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

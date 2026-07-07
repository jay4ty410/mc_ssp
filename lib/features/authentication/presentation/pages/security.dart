// security.dart
//
// MC_SS Smart Scheduler — Security & Privacy screen.
//
// Drop-in usage:
//   1. If your project already defines `AppColorsExt` / `context.appColors`
//      in `app_theme.dart`, delete the `AppColorsExt` block below and the
//      `ThemeData.extensions` line in `main()`, then import your theme file
//      instead — the token names used here match the project's canonical
//      palette (MC_SS_Color_Palette_and_Theme_Guide) so no renaming is
//      required.
//   2. If you already have `app_bottom_navigation_bar.dart`, swap out
//      `_SecurityBottomNavBar` for that shared widget (Tasks/Profile sit at
//      indices 2/3, center FAB handled via a separate `onCenterTap`
//      callback — see the note on `_SecurityBottomNavBar` below).
//
// No third-party packages are used; only standard Material widgets.

import 'package:flutter/material.dart';
import 'package:mc_ssp/core/widgets/app_bottom_navigation_bar.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/home_screen.dart'
    show HomeScreen;
import 'package:mc_ssp/features/calendar.dart' show CalendarScreen;
import 'package:mc_ssp/features/task_list.dart' show TaskListScreen;

// -----------------------------------------------------------------------
// THEME — AppColorsExt
// -----------------------------------------------------------------------
// Semantic color tokens sourced from MC_SS_Color_Palette_and_Theme_Guide.
// Keep all screen-level widgets free of inline hex values; pull colors via
// `context.appColors` instead.

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.divider,
    required this.primary,
    required this.secondaryCyan,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.success,
    required this.successSoftBg,
    required this.info,
    required this.infoSoftBg,
    required this.purpleAccent,
    required this.purpleSoftBg,
    required this.orangeAccent,
    required this.orangeSoftBg,
  });

  final Color scaffoldBackground;
  final Color cardBackground;
  final Color divider;
  final Color primary;
  final Color secondaryCyan;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color success;
  final Color successSoftBg;
  final Color info;
  final Color infoSoftBg;
  final Color purpleAccent;
  final Color purpleSoftBg;
  final Color orangeAccent;
  final Color orangeSoftBg;

  static const light = AppColorsExt(
    scaffoldBackground: Color(0xFFF8FAFD),
    cardBackground: Color(0xFFFFFFFF),
    divider: Color(0xFFE8EDF5),
    primary: Color(0xFF1565FF),
    secondaryCyan: Color(0xFF2EC5FF),
    textPrimary: Color(0xFF1C2434),
    textSecondary: Color(0xFF6C7A92),
    textDisabled: Color(0xFFA9B4C5),
    success: Color(0xFF34C759),
    successSoftBg: Color(0xFFE3F8E9),
    info: Color(0xFF4A90E2),
    infoSoftBg: Color(0xFFE7F0FD),
    purpleAccent: Color(0xFF6C63FF),
    purpleSoftBg: Color(0xFFEDECFF),
    orangeAccent: Color(0xFFFFC542),
    orangeSoftBg: Color(0xFFFFF3DA),
  );

  static const dark = AppColorsExt(
    scaffoldBackground: Color(0xFF0B1228),
    cardBackground: Color(0xFF18233D),
    divider: Color(0xFF26324D),
    primary: Color(0xFF2E7DFF),
    secondaryCyan: Color(0xFF3DDCFF),
    textPrimary: Color(0xFFF5F7FA),
    textSecondary: Color(0xFFB7C3D7),
    textDisabled: Color(0xFF7D8CA3),
    success: Color(0xFF4CD964),
    successSoftBg: Color(0xFF16321F),
    info: Color(0xFF64B5F6),
    infoSoftBg: Color(0xFF152A45),
    purpleAccent: Color(0xFF8B7CFF),
    purpleSoftBg: Color(0xFF251F45),
    orangeAccent: Color(0xFFFFD166),
    orangeSoftBg: Color(0xFF3A2E12),
  );

  @override
  AppColorsExt copyWith({
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? divider,
    Color? primary,
    Color? secondaryCyan,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? success,
    Color? successSoftBg,
    Color? info,
    Color? infoSoftBg,
    Color? purpleAccent,
    Color? purpleSoftBg,
    Color? orangeAccent,
    Color? orangeSoftBg,
  }) {
    return AppColorsExt(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
      primary: primary ?? this.primary,
      secondaryCyan: secondaryCyan ?? this.secondaryCyan,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      successSoftBg: successSoftBg ?? this.successSoftBg,
      info: info ?? this.info,
      infoSoftBg: infoSoftBg ?? this.infoSoftBg,
      purpleAccent: purpleAccent ?? this.purpleAccent,
      purpleSoftBg: purpleSoftBg ?? this.purpleSoftBg,
      orangeAccent: orangeAccent ?? this.orangeAccent,
      orangeSoftBg: orangeSoftBg ?? this.orangeSoftBg,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondaryCyan: Color.lerp(secondaryCyan, other.secondaryCyan, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoftBg: Color.lerp(successSoftBg, other.successSoftBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoSoftBg: Color.lerp(infoSoftBg, other.infoSoftBg, t)!,
      purpleAccent: Color.lerp(purpleAccent, other.purpleAccent, t)!,
      purpleSoftBg: Color.lerp(purpleSoftBg, other.purpleSoftBg, t)!,
      orangeAccent: Color.lerp(orangeAccent, other.orangeAccent, t)!,
      orangeSoftBg: Color.lerp(orangeSoftBg, other.orangeSoftBg, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;
}

// -----------------------------------------------------------------------
// DATA MODELS — enum-driven row rendering
// -----------------------------------------------------------------------

/// How the trailing side of a [_SecurityRowData] should render.
enum _TrailingKind { chevronOnly, badge, label }

@immutable
class _SecurityRowData {
  const _SecurityRowData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.trailingKind = _TrailingKind.chevronOnly,
    this.trailingText,
    this.isSolidStatusIcon = false,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final _TrailingKind trailingKind;
  final String? trailingText;

  /// True for the "Your account is secure" row — rendered as a solid
  /// filled circle with a white check, instead of a soft-tint square.
  final bool isSolidStatusIcon;

  final VoidCallback? onTap;
}

@immutable
class _SecuritySectionData {
  const _SecuritySectionData({required this.header, required this.rows});

  final String header;
  final List<_SecurityRowData> rows;
}

// -----------------------------------------------------------------------
// SCREEN
// -----------------------------------------------------------------------

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  List<_SecuritySectionData> _buildSections(BuildContext context) {
    final colors = context.appColors;

    return [
      _SecuritySectionData(
        header: 'Account Security',
        rows: [
          _SecurityRowData(
            icon: Icons.lock_outline,
            iconColor: colors.success,
            iconBg: colors.successSoftBg,
            title: 'Change Password',
            subtitle: 'Update your password regularly',
            // TODO: navigate to change-password flow.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.smartphone_outlined,
            iconColor: colors.info,
            iconBg: colors.infoSoftBg,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            trailingKind: _TrailingKind.badge,
            trailingText: 'Enabled',
            // TODO: navigate to 2FA settings.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.shield_outlined,
            iconColor: colors.purpleAccent,
            iconBg: colors.purpleSoftBg,
            title: 'Login Sessions',
            subtitle: 'Manage your active sessions',
            // TODO: navigate to active sessions list.
            onTap: () {},
          ),
        ],
      ),
      _SecuritySectionData(
        header: 'Privacy Settings',
        rows: [
          _SecurityRowData(
            icon: Icons.visibility_outlined,
            iconColor: colors.orangeAccent,
            iconBg: colors.orangeSoftBg,
            title: 'Profile Visibility',
            subtitle: 'Control who can see your profile',
            trailingKind: _TrailingKind.label,
            trailingText: 'Team Members',
            // TODO: navigate to visibility settings.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.people_outline,
            iconColor: colors.purpleAccent,
            iconBg: colors.purpleSoftBg,
            title: 'Data Sharing',
            subtitle: 'Manage your data sharing preferences',
            trailingKind: _TrailingKind.label,
            trailingText: 'Limited',
            // TODO: navigate to data-sharing settings.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.description_outlined,
            iconColor: colors.info,
            iconBg: colors.infoSoftBg,
            title: 'Activity History',
            subtitle: 'View and manage your activity history',
            // TODO: navigate to activity history.
            onTap: () {},
          ),
        ],
      ),
      _SecuritySectionData(
        header: 'Security Status',
        rows: [
          _SecurityRowData(
            icon: Icons.check,
            iconColor: Colors.white,
            iconBg: colors.success,
            isSolidStatusIcon: true,
            title: 'Your account is secure',
            subtitle: 'All security settings are up to date',
            // TODO: navigate to full security status detail.
            onTap: () {},
          ),
        ],
      ),
      _SecuritySectionData(
        header: 'Recent Security Activity',
        rows: [
          _SecurityRowData(
            icon: Icons.lock_outline,
            iconColor: colors.success,
            iconBg: colors.successSoftBg,
            title: 'Password Changed',
            subtitle: '2 days ago • Chrome on Windows',
            // TODO: navigate to activity detail.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.login,
            iconColor: colors.info,
            iconBg: colors.infoSoftBg,
            title: 'Successful Login',
            subtitle: '3 days ago • Chrome on Windows',
            // TODO: navigate to activity detail.
            onTap: () {},
          ),
          _SecurityRowData(
            icon: Icons.login,
            iconColor: colors.info,
            iconBg: colors.infoSoftBg,
            title: 'Successful Login',
            subtitle: '1 week ago • Mobile App on Android',
            // TODO: navigate to activity detail.
            onTap: () {},
          ),
        ],
      ),
    ];
  }

  void _navigateToTab(BuildContext context, int index) {
    if (index == 3) return;

    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      1 => const CalendarScreen(),
      2 => const TaskListScreen(),
      _ => const SecurityScreen(),
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sections = _buildSections(context);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _SecurityAppBar(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final section in sections) ...[
                      _SectionCard(section: section),
                      const SizedBox(height: 16),
                    ],
                    const _NeedHelpCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) => _navigateToTab(context, index),
        onCenterTap: () => _showQuickAddModal(context),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// APP BAR
// -----------------------------------------------------------------------

class _SecurityAppBar extends StatelessWidget {
  const _SecurityAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage your account security and privacy',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.successSoftBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shield_outlined,
                color: colors.success,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------
// SECTION CARD
// -----------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final _SecuritySectionData section;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.divider),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.header,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          for (int i = 0; i < section.rows.length; i++) ...[
            _SecurityListTile(data: section.rows[i]),
            if (i != section.rows.length - 1)
              Divider(height: 1, thickness: 1, color: colors.divider),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------
// LIST TILE ROW
// -----------------------------------------------------------------------

class _SecurityListTile extends StatelessWidget {
  const _SecurityListTile({required this.data});

  final _SecurityRowData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _RowIcon(data: data),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _RowTrailing(data: data),
          ],
        ),
      ),
    );
  }
}

class _RowIcon extends StatelessWidget {
  const _RowIcon({required this.data});

  final _SecurityRowData data;

  @override
  Widget build(BuildContext context) {
    final shape = data.isSolidStatusIcon ? BoxShape.circle : BoxShape.rectangle;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: data.iconBg,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(11)
            : null,
      ),
      child: Icon(data.icon, color: data.iconColor, size: 20),
    );
  }
}

class _RowTrailing extends StatelessWidget {
  const _RowTrailing({required this.data});

  final _SecurityRowData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final chevron = Icon(
      Icons.chevron_right,
      color: colors.textSecondary,
      size: 22,
    );

    switch (data.trailingKind) {
      case _TrailingKind.chevronOnly:
        return chevron;
      case _TrailingKind.label:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.trailingText ?? '',
              style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
            ),
            const SizedBox(width: 4),
            chevron,
          ],
        );
      case _TrailingKind.badge:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusBadge(text: data.trailingText ?? ''),
            const SizedBox(width: 6),
            chevron,
          ],
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colors.successSoftBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: colors.success,
        ),
      ),
    );
  }
}

class _QuickAddOption extends StatelessWidget {
  const _QuickAddOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

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

// -----------------------------------------------------------------------
// NEED HELP CARD
// -----------------------------------------------------------------------

class _NeedHelpCard extends StatelessWidget {
  const _NeedHelpCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.divider),
      ),
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'If you notice any suspicious activity, contact our '
                'support team immediately.',
                style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
              ),
            ],
          );

          final button = OutlinedButton(
            // TODO: wire up support contact flow.
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );

          // Wrap to a column on narrow widths so the button never
          // squeezes the copy below a comfortable reading width.
          if (constraints.maxWidth < 380) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [textColumn, const SizedBox(height: 14), button],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textColumn),
              const SizedBox(width: 16),
              button,
            ],
          );
        },
      ),
    );
  }
}

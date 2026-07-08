// ============================================================================
// preferences.dart
// ----------------------------------------------------------------------------
// MC_SS Smart Scheduler — Preferences Screen
//
// COLOR MAPPING
// ----------------------------------------------------------------------------
// This screen is written against a semantic `AppColorsExt` ThemeExtension,
// consistent with the rest of the MC_SS codebase (app_theme.dart). If your
// extension already defines these tokens, just make sure the names below
// line up (or adjust the getters in `context.appColors`). A fallback
// `_Palette` class is included further down with raw hex constants so the
// file is still copy-paste runnable even before the extension is wired up.
//
// Expected AppColorsExt tokens used on this screen:
//   background            - page scaffold background (soft grayish-blue)
//   surface               - card background (white)
//   textPrimary           - bold titles
//   textSecondary         - muted subtitles
//   divider               - thin separators inside cards
//   primary               - accent blue (selected segment, ON switches, FAB)
//   iconBoxBlue / onIconBlue     - Theme
//   iconBoxGreen / onIconGreen   - Language
//   iconBoxOrange / onIconOrange - Time Format / Due Date Reminders
//   iconBoxPurple / onIconPurple - Calendar / Mark Completed
//   iconBoxGray / onIconGray     - Hide Completed Tasks
//   settingsBadgeBg / settingsBadgeIcon - top-right settings button
//
// If these tokens don't exist yet in AppColorsExt, add them there rather
// than inlining hex values here — that keeps this screen theme-safe across
// light/dark mode.
// ============================================================================

import 'package:flutter/material.dart';

// -----------------------------------------------------------------------
// Fallback palette (remove once AppColorsExt tokens above are confirmed).
// Swap `context.appColors.X` calls below for `_Palette.X` only if you need
// to run this screen standalone without the extension present.
// -----------------------------------------------------------------------
class _Palette {
  _Palette();

  final Color background = Color(0xFFF3F5FA);
  final Color surface = Colors.white;
  final Color textPrimary = Color(0xFF16213E);
  final Color textSecondary = Color(0xFF8A8FA3);
  final Color divider = Color(0xFFEDEFF5);
  final Color primary = Color(0xFF3E6BF2);

  final Color iconBoxBlue = Color(0xFFE3ECFD);
  final Color onIconBlue = Color(0xFF3E6BF2);

  final Color iconBoxGreen = Color(0xFFE1F5E9);
  final Color onIconGreen = Color(0xFF34A853);

  final Color iconBoxOrange = Color(0xFFFDEBD8);
  final Color onIconOrange = Color(0xFFF0932B);

  final Color iconBoxPurple = Color(0xFFEBE3FB);
  final Color onIconPurple = Color(0xFF7B4FE0);

  final Color iconBoxGray = Color(0xFFEDEFF3);
  final Color onIconGray = Color(0xFF9AA0AC);

  final Color settingsBadgeBg = Color(0xFFF1E7FE);
  final Color settingsBadgeIcon = Color(0xFF8B4FE0);
}

// If you already have `context.appColors` wired up via a ThemeExtension,
// this file assumes calls like `context.appColors.background`. Until then,
// the getters below just forward to `_Palette` so the file compiles as-is.
extension _AppColorsShim on BuildContext {
  _Palette get appColors => _Palette();
}

// -----------------------------------------------------------------------
// Data modeling
// -----------------------------------------------------------------------

/// The kind of trailing control a preference row renders.
enum _TrailingType { chevron, toggle, segment }

/// A small, reusable color pairing for a leading icon "chip".
class _IconStyle {
  final Color background;
  final Color foreground;
  const _IconStyle(this.background, this.foreground);
}

/// Declarative description of a single preference row. Rows are rendered by
/// `_PreferenceRow`, keeping section widgets purely data-driven.
class _PreferenceItem {
  final IconData icon;
  final _IconStyle iconStyle;
  final String title;
  final String subtitle;
  final _TrailingType trailingType;

  /// Used when [trailingType] is `chevron`.
  final String? valueLabel;
  final VoidCallback? onTap;

  /// Used when [trailingType] is `toggle`.
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const _PreferenceItem({
    required this.icon,
    required this.iconStyle,
    required this.title,
    required this.subtitle,
    required this.trailingType,
    this.valueLabel,
    this.onTap,
    this.toggleValue,
    this.onToggleChanged,
  });
}

// -----------------------------------------------------------------------
// PreferencesPage
// -----------------------------------------------------------------------

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  // --- General ---
  int _themeIndex = 0; // 0 = Light, 1 = Dark, 2 = System
  final String _language = 'English';
  final String _timeFormat = '12-hour (AM/PM)';
  final String _firstDayOfWeek = 'Monday';

  // --- Tasks & Calendar ---
  final String _defaultTaskView = 'List View';
  bool _autoAddTasksToCalendar = true;
  bool _dueDateReminders = true;
  bool _markTasksAsCompletedSound = true;
  bool _hideCompletedTasks = false;

  // --- Display ---
  final String _displayDensity = 'Comfortable';
  final String _calendarView = 'Week View';
  final String _colorPreference = 'Vibrant';

  // --- Data & Sync ---
  bool _syncAcrossDevices = true;

  void _onSettingsTap() {
    // TODO: navigate to advanced settings, or no-op if this IS that screen.
  }

  void _onBackTap() {
    // TODO: wire to Navigator.pop(context) once routed from a parent screen.
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // Placeholder navigators for chevron rows — wire these to real picker
  // sheets / sub-screens as they're built out.
  void _pickLanguage() {
    // TODO: open language picker.
  }

  void _pickTimeFormat() {
    // TODO: open time format picker.
  }

  void _pickFirstDayOfWeek() {
    // TODO: open first-day-of-week picker.
  }

  void _pickDefaultTaskView() {
    // TODO: open default task view picker.
  }

  void _pickDisplayDensity() {
    // TODO: open display density picker.
  }

  void _pickCalendarView() {
    // TODO: open calendar view picker.
  }

  void _pickColorPreference() {
    // TODO: open color preference picker.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final generalItems = <_PreferenceItem>[
      _PreferenceItem(
        icon: Icons.palette_outlined,
        iconStyle: _IconStyle(colors.iconBoxBlue, colors.onIconBlue),
        title: 'Theme',
        subtitle: 'Choose your preferred theme',
        trailingType: _TrailingType.segment,
      ),
      _PreferenceItem(
        icon: Icons.translate,
        iconStyle: _IconStyle(colors.iconBoxGreen, colors.onIconGreen),
        title: 'Language',
        subtitle: 'Select your app language',
        trailingType: _TrailingType.chevron,
        valueLabel: _language,
        onTap: _pickLanguage,
      ),
      _PreferenceItem(
        icon: Icons.access_time,
        iconStyle: _IconStyle(colors.iconBoxOrange, colors.onIconOrange),
        title: 'Time Format',
        subtitle: 'Choose how time is displayed',
        trailingType: _TrailingType.chevron,
        valueLabel: _timeFormat,
        onTap: _pickTimeFormat,
      ),
      _PreferenceItem(
        icon: Icons.calendar_today_outlined,
        iconStyle: _IconStyle(colors.iconBoxPurple, colors.onIconPurple),
        title: 'First Day of Week',
        subtitle: 'Select the first day of the week',
        trailingType: _TrailingType.chevron,
        valueLabel: _firstDayOfWeek,
        onTap: _pickFirstDayOfWeek,
      ),
    ];

    final tasksAndCalendarItems = <_PreferenceItem>[
      _PreferenceItem(
        icon: Icons.list_alt_outlined,
        iconStyle: _IconStyle(colors.iconBoxBlue, colors.onIconBlue),
        title: 'Default Task View',
        subtitle: 'Choose your default task view',
        trailingType: _TrailingType.chevron,
        valueLabel: _defaultTaskView,
        onTap: _pickDefaultTaskView,
      ),
      _PreferenceItem(
        icon: Icons.notifications_none_rounded,
        iconStyle: _IconStyle(colors.iconBoxGreen, colors.onIconGreen),
        title: 'Auto Add Tasks to Calendar',
        subtitle: 'Automatically add tasks to your calendar',
        trailingType: _TrailingType.toggle,
        toggleValue: _autoAddTasksToCalendar,
        onToggleChanged: (v) => setState(() => _autoAddTasksToCalendar = v),
      ),
      _PreferenceItem(
        icon: Icons.access_time,
        iconStyle: _IconStyle(colors.iconBoxOrange, colors.onIconOrange),
        title: 'Due Date Reminders',
        subtitle: 'Get reminded about upcoming due dates',
        trailingType: _TrailingType.toggle,
        toggleValue: _dueDateReminders,
        onToggleChanged: (v) => setState(() => _dueDateReminders = v),
      ),
      _PreferenceItem(
        icon: Icons.check_circle_outline,
        iconStyle: _IconStyle(colors.iconBoxPurple, colors.onIconPurple),
        title: 'Mark Tasks as Completed',
        subtitle: 'Play a sound when marking tasks complete',
        trailingType: _TrailingType.toggle,
        toggleValue: _markTasksAsCompletedSound,
        onToggleChanged: (v) => setState(() => _markTasksAsCompletedSound = v),
      ),
      _PreferenceItem(
        icon: Icons.visibility_off_outlined,
        iconStyle: _IconStyle(colors.iconBoxGray, colors.onIconGray),
        title: 'Hide Completed Tasks',
        subtitle: 'Hide completed tasks from default view',
        trailingType: _TrailingType.toggle,
        toggleValue: _hideCompletedTasks,
        onToggleChanged: (v) => setState(() => _hideCompletedTasks = v),
      ),
    ];

    final displayItems = <_PreferenceItem>[
      _PreferenceItem(
        icon: Icons.dashboard_customize_outlined,
        iconStyle: _IconStyle(colors.iconBoxBlue, colors.onIconBlue),
        title: 'Display Density',
        subtitle: 'Adjust the size of elements on screen',
        trailingType: _TrailingType.chevron,
        valueLabel: _displayDensity,
        onTap: _pickDisplayDensity,
      ),
      _PreferenceItem(
        icon: Icons.view_column_outlined,
        iconStyle: _IconStyle(colors.iconBoxGreen, colors.onIconGreen),
        title: 'Calendar View',
        subtitle: 'Choose how calendar events are displayed',
        trailingType: _TrailingType.chevron,
        valueLabel: _calendarView,
        onTap: _pickCalendarView,
      ),
      _PreferenceItem(
        icon: Icons.color_lens_outlined,
        iconStyle: _IconStyle(colors.iconBoxOrange, colors.onIconOrange),
        title: 'Color Preference',
        subtitle: 'Choose how colors are used in the app',
        trailingType: _TrailingType.chevron,
        valueLabel: _colorPreference,
        onTap: _pickColorPreference,
      ),
    ];

    final dataAndSyncItems = <_PreferenceItem>[
      _PreferenceItem(
        icon: Icons.cloud_outlined,
        iconStyle: _IconStyle(colors.iconBoxPurple, colors.onIconPurple),
        title: 'Sync Across Devices',
        subtitle: 'Keep your data synced across all devices',
        trailingType: _TrailingType.toggle,
        toggleValue: _syncAcrossDevices,
        onToggleChanged: (v) => setState(() => _syncAcrossDevices = v),
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _PreferencesHeader(
              onBackTap: _onBackTap,
              onSettingsTap: _onSettingsTap,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    _SectionCard(
                      title: 'General',
                      children: [
                        for (final item in generalItems)
                          _PreferenceRow(
                            item: item,
                            trailingBuilder:
                                item.trailingType == _TrailingType.segment
                                ? (_) => _ThemeSegmentedControl(
                                    selectedIndex: _themeIndex,
                                    onChanged: (i) =>
                                        setState(() => _themeIndex = i),
                                  )
                                : null,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Tasks & Calendar',
                      children: [
                        for (final item in tasksAndCalendarItems)
                          _PreferenceRow(item: item),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Display',
                      children: [
                        for (final item in displayItems)
                          _PreferenceRow(item: item),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Data & Sync',
                      children: [
                        for (final item in dataAndSyncItems)
                          _PreferenceRow(item: item),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------

class _PreferencesHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onSettingsTap;

  const _PreferencesHeader({
    required this.onBackTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize your app experience',
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _SettingsBadgeButton(onTap: onSettingsTap),
          ),
        ],
      ),
    );
  }
}

class _SettingsBadgeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SettingsBadgeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.settingsBadgeBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          child: Icon(
            Icons.settings_rounded,
            color: colors.settingsBadgeIcon,
            size: 26,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Section card
// -----------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
          ),
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, thickness: 1, color: colors.divider),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Preference row
// -----------------------------------------------------------------------

/// Renders a single preference row from a [_PreferenceItem]. For rows that
/// need a bespoke trailing widget (e.g. the theme segmented control),
/// pass [trailingBuilder]; otherwise the row derives the trailing widget
/// from `item.trailingType`.
class _PreferenceRow extends StatelessWidget {
  final _PreferenceItem item;
  final Widget Function(BuildContext)? trailingBuilder;

  const _PreferenceRow({required this.item, this.trailingBuilder});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget trailing;
    if (trailingBuilder != null) {
      trailing = trailingBuilder!(context);
    } else {
      switch (item.trailingType) {
        case _TrailingType.toggle:
          trailing = Switch.adaptive(
            value: item.toggleValue ?? false,
            activeColor: colors.primary,
            onChanged: item.onToggleChanged ?? (_) {},
          );
          break;
        case _TrailingType.chevron:
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.valueLabel ?? '',
                style: TextStyle(fontSize: 14.5, color: colors.textSecondary),
              ),
              const SizedBox(width: 2),
              Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
            ],
          );
          break;
        case _TrailingType.segment:
          trailing = const SizedBox.shrink();
          break;
      }
    }

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconBox(icon: item.icon, style: item.iconStyle),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );

    if (item.trailingType == _TrailingType.chevron && item.onTap != null) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: row,
      );
    }
    return row;
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final _IconStyle style;

  const _IconBox({required this.icon, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: style.foreground, size: 20),
    );
  }
}

// -----------------------------------------------------------------------
// Theme segmented control (Light / Dark / System)
// -----------------------------------------------------------------------

class _ThemeSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['Light', 'Dark', 'System'];

  const _ThemeSegmentedControl({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _labels.length; i++)
            _SegmentButton(
              label: _labels[i],
              isSelected: i == selectedIndex,
              onTap: () => onChanged(i),
            ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: colors.primary.withValues(alpha: 0.35))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Bottom navigation bar
// -----------------------------------------------------------------------
// NOTE: If `app_bottom_navigation_bar.dart` already exists in the project
// (per earlier screens), prefer that shared widget instead of this local
// copy — keep only one implementation of the nav bar. This local version
// is included so `preferences.dart` is runnable standalone. Remember: the
// center FAB is NOT part of the 4-item tab index array; Tasks = index 2,
// Profile = index 3.

class _PreferencesBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const _PreferencesBottomNavBar({
    required this.activeIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    const items = <(_NavIconSpec, String)>[
      (_NavIconSpec(Icons.home_outlined, Icons.home), 'Home'),
      (
        _NavIconSpec(Icons.calendar_today_outlined, Icons.calendar_today),
        'Calendar',
      ),
      (
        _NavIconSpec(Icons.checklist_rtl_outlined, Icons.checklist_rtl),
        'Tasks',
      ),
      (_NavIconSpec(Icons.person_outline, Icons.person), 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavBarItem(
                spec: items[0].$1,
                label: items[0].$2,
                isActive: activeIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                spec: items[1].$1,
                label: items[1].$2,
                isActive: activeIndex == 1,
                onTap: () => onTap(1),
              ),
              _CenterFabItem(onTap: onCenterTap),
              _NavBarItem(
                spec: items[2].$1,
                label: items[2].$2,
                isActive: activeIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                spec: items[3].$1,
                label: items[3].$2,
                isActive: activeIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconSpec {
  final IconData outlined;
  final IconData filled;
  const _NavIconSpec(this.outlined, this.filled);
}

class _NavBarItem extends StatelessWidget {
  final _NavIconSpec spec;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.spec,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = isActive ? colors.primary : colors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? spec.filled : spec.outlined,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterFabItem extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterFabItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -10),
          child: Material(
            color: colors.primary,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 52,
                height: 52,
                child: Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

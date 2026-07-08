import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// Enums — declarative, style-map driven UI variants
/// -----------------------------------------------------------------------

enum AppThemeMode { light, dark, system }

extension AppThemeModeX on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  String get caption {
    switch (this) {
      case AppThemeMode.light:
        return 'Bright and clean';
      case AppThemeMode.dark:
        return 'Easy on the eyes';
      case AppThemeMode.system:
        return 'Use device setting';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.wb_sunny_rounded;
      case AppThemeMode.dark:
        return Icons.nightlight_round;
      case AppThemeMode.system:
        return Icons.contrast_rounded;
    }
  }
}

enum AccentColorOption { blue, purple, green, orange, red, cyan }

extension AccentColorOptionX on AccentColorOption {
  /// NOTE: These are literal, user-selectable swatch colors defined by the
  /// design spec — not theme-mode-dependent tokens — so they are kept local
  /// rather than pulled from AppColorsExt.
  Color color(BuildContext context) {
    switch (this) {
      case AccentColorOption.blue:
        return context.appColors.primaryBlue;
      case AccentColorOption.purple:
        return const Color(0xFF6C63FF);
      case AccentColorOption.green:
        return const Color(0xFF34C759);
      case AccentColorOption.orange:
        return const Color(0xFFFFC542);
      case AccentColorOption.red:
        return const Color(0xFFFF5A5F);
      case AccentColorOption.cyan:
        return context.appColors.secondaryCyan;
    }
  }
}

enum AppFontSize { small, medium, large }

extension AppFontSizeX on AppFontSize {
  String get label {
    switch (this) {
      case AppFontSize.small:
        return 'Small';
      case AppFontSize.medium:
        return 'Medium';
      case AppFontSize.large:
        return 'Large';
    }
  }
}

/// -----------------------------------------------------------------------
/// Theme tokens used by this screen
/// -----------------------------------------------------------------------

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.mainBackground,
    required this.cardBackground,
    required this.primaryBlue,
    required this.secondaryCyan,
    required this.primaryText,
    required this.secondaryText,
    required this.secondaryBackground,
    required this.divider,
    required this.softShadow,
  });

  final Color mainBackground;
  final Color cardBackground;
  final Color primaryBlue;
  final Color secondaryCyan;
  final Color primaryText;
  final Color secondaryText;
  final Color secondaryBackground;
  final Color divider;
  final List<BoxShadow> softShadow;

  static const light = AppColorsExt(
    mainBackground: Color(0xFFF8FAFD),
    cardBackground: Color(0xFFFFFFFF),
    primaryBlue: Color(0xFF1565FF),
    secondaryCyan: Color(0xFF2EC5FF),
    primaryText: Color(0xFF1C2434),
    secondaryText: Color(0xFF6C7A92),
    secondaryBackground: Color(0xFFEEF4FF),
    divider: Color(0xFFE8EDF5),
    softShadow: [
      BoxShadow(color: Color(0x0F1C2434), blurRadius: 16, offset: Offset(0, 6)),
    ],
  );

  @override
  AppColorsExt copyWith({
    Color? mainBackground,
    Color? cardBackground,
    Color? primaryBlue,
    Color? secondaryCyan,
    Color? primaryText,
    Color? secondaryText,
    Color? secondaryBackground,
    Color? divider,
    List<BoxShadow>? softShadow,
  }) {
    return AppColorsExt(
      mainBackground: mainBackground ?? this.mainBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      primaryBlue: primaryBlue ?? this.primaryBlue,
      secondaryCyan: secondaryCyan ?? this.secondaryCyan,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      divider: divider ?? this.divider,
      softShadow: softShadow ?? this.softShadow,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      mainBackground: Color.lerp(mainBackground, other.mainBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      secondaryCyan: Color.lerp(secondaryCyan, other.secondaryCyan, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      secondaryBackground: Color.lerp(
        secondaryBackground,
        other.secondaryBackground,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
      softShadow: t < 0.5 ? softShadow : other.softShadow,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExt get appColors =>
      Theme.of(this).extension<AppColorsExt>() ?? AppColorsExt.light;
}

/// -----------------------------------------------------------------------
/// Screen
/// -----------------------------------------------------------------------

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  AppThemeMode _selectedTheme = AppThemeMode.light;
  AccentColorOption _selectedAccent = AccentColorOption.blue;
  AppFontSize _selectedFontSize = AppFontSize.medium;

  bool _reduceMotion = false;
  bool _highContrast = false;
  bool _compactMode = false;

  void _onThemeSelected(AppThemeMode mode) {
    setState(() => _selectedTheme = mode);
    // TODO: Persist selected theme mode (e.g. via Riverpod/Bloc/Provider + local storage).
  }

  void _onAccentSelected(AccentColorOption accent) {
    setState(() => _selectedAccent = accent);
    // TODO: Persist selected accent color and propagate to app theme.
  }

  void _onFontSizeSelected(AppFontSize size) {
    setState(() => _selectedFontSize = size);
    // TODO: Persist font size preference.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.mainBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),
                  _BrandingRow(colors: colors),
                  const SizedBox(height: 24),
                  _PageHeader(colors: colors),
                  const SizedBox(height: 24),
                  _SectionCard(
                    colors: colors,
                    child: _ThemeSection(
                      colors: colors,
                      selected: _selectedTheme,
                      onSelected: _onThemeSelected,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    colors: colors,
                    child: _AccentColorSection(
                      colors: colors,
                      selected: _selectedAccent,
                      onSelected: _onAccentSelected,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    padding: EdgeInsets.zero,
                    colors: colors,
                    child: _DisplayOptionsSection(
                      colors: colors,
                      fontSize: _selectedFontSize,
                      reduceMotion: _reduceMotion,
                      highContrast: _highContrast,
                      compactMode: _compactMode,
                      onFontSizeTap: () => _showFontSizePicker(context),
                      onReduceMotionChanged: (v) =>
                          setState(() => _reduceMotion = v),
                      onHighContrastChanged: (v) =>
                          setState(() => _highContrast = v),
                      onCompactModeChanged: (v) =>
                          setState(() => _compactMode = v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    colors: colors,
                    child: _PreviewSection(colors: colors),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.appColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final colors = sheetContext.appColors;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppFontSize.values.map((size) {
                final isSelected = size == _selectedFontSize;
                return ListTile(
                  title: Text(
                    size.label,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: colors.primaryBlue)
                      : null,
                  onTap: () {
                    _onFontSizeSelected(size);
                    Navigator.of(sheetContext).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// -----------------------------------------------------------------------
/// A. Branding row + Page header
/// -----------------------------------------------------------------------

class _BrandingRow extends StatelessWidget {
  const _BrandingRow({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // TODO: Replace with the actual asset, e.g. assets/logo.png
        Image.asset(
          'assets/images/register01.png',
          height: 80,
          errorBuilder: (context, error, stackTrace) => Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: colors.primaryBlue,
                size: 28,
              ),
            ],
          ),
        ),
        const Spacer(),
        _CircleIconButton(
          colors: colors,
          icon: Icons.notifications_none_rounded,
          badgeCount: 3,
          onTap: () {
            // TODO: Navigate to notifications screen.
          },
        ),
        const SizedBox(width: 12),
        _CircleIconButton(
          colors: colors,
          icon: Icons.person_outline_rounded,
          onTap: () {
            // TODO: Navigate to profile screen.
          },
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.colors,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  final AppColorsExt colors;
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.cardBackground,
              shape: BoxShape.circle,
              boxShadow: colors.softShadow,
            ),
            child: Icon(icon, color: colors.primaryText, size: 22),
          ),
          if (badgeCount != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.cardBackground, width: 1.5),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$badgeCount',
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
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Icon(
              Icons.arrow_back_rounded,
              color: colors.primaryText,
              size: 26,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose theme and display options',
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// Shared section card + header
/// -----------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.colors,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final AppColorsExt colors;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: colors.softShadow,
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.colors,
    required this.title,
    required this.subtitle,
    this.padding = EdgeInsets.zero,
  });

  final AppColorsExt colors;
  final String title;
  final String subtitle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: colors.secondaryText, fontSize: 12.5),
            ),
          ],
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// B. Theme Selection Section
/// -----------------------------------------------------------------------

class _ThemeSection extends StatelessWidget {
  const _ThemeSection({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final AppColorsExt colors;
  final AppThemeMode selected;
  final ValueChanged<AppThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          colors: colors,
          title: 'Theme',
          subtitle: 'Choose your preferred theme',
        ),
        const SizedBox(height: 16),
        Row(
          children: AppThemeMode.values.map((mode) {
            final isLast = mode == AppThemeMode.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 12),
                child: _ThemeCard(
                  colors: colors,
                  mode: mode,
                  isSelected: mode == selected,
                  onTap: () => onSelected(mode),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.colors,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final AppColorsExt colors;
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.secondaryBackground
                  : colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colors.primaryBlue : colors.divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  mode.icon,
                  size: 28,
                  color: isSelected ? colors.primaryBlue : colors.secondaryText,
                ),
                const SizedBox(height: 12),
                Text(
                  mode.label,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mode.caption,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.secondaryText, fontSize: 11),
                ),
              ],
            ),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isSelected ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.cardBackground, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// C. Accent Color Section
/// -----------------------------------------------------------------------

class _AccentColorSection extends StatelessWidget {
  const _AccentColorSection({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final AppColorsExt colors;
  final AccentColorOption selected;
  final ValueChanged<AccentColorOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          colors: colors,
          title: 'Accent Color',
          subtitle: 'Choose your favorite accent color',
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AccentColorOption.values.map((option) {
              final isLast = option == AccentColorOption.values.last;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 14),
                child: _AccentSwatch(
                  color: option.color(context),
                  isSelected: option == selected,
                  onTap: () => onSelected(option),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: color.withValues(alpha: 0.35), width: 4)
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// D. Display Options Section
/// -----------------------------------------------------------------------

class _DisplayOptionRowData {
  const _DisplayOptionRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _DisplayOptionsSection extends StatelessWidget {
  const _DisplayOptionsSection({
    required this.colors,
    required this.fontSize,
    required this.reduceMotion,
    required this.highContrast,
    required this.compactMode,
    required this.onFontSizeTap,
    required this.onReduceMotionChanged,
    required this.onHighContrastChanged,
    required this.onCompactModeChanged,
  });

  final AppColorsExt colors;
  final AppFontSize fontSize;
  final bool reduceMotion;
  final bool highContrast;
  final bool compactMode;
  final VoidCallback onFontSizeTap;
  final ValueChanged<bool> onReduceMotionChanged;
  final ValueChanged<bool> onHighContrastChanged;
  final ValueChanged<bool> onCompactModeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          colors: colors,
          title: 'Display Options',
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          subtitle: '',
        ),
        const SizedBox(height: 4),
        _OptionRow(
          colors: colors,
          data: const _DisplayOptionRowData(
            icon: Icons.text_fields_rounded,
            title: 'Font Size',
            subtitle: 'Adjust the app font size',
          ),
          trailing: InkWell(
            onTap: onFontSizeTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fontSize.label,
                    style: TextStyle(
                      color: colors.primaryBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.primaryBlue,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, color: colors.divider, indent: 20, endIndent: 20),
        _OptionRow(
          colors: colors,
          data: const _DisplayOptionRowData(
            icon: Icons.auto_awesome_rounded,
            title: 'Reduce Motion',
            subtitle: 'Minimize animations throughout the app',
          ),
          trailing: Switch(
            value: reduceMotion,
            onChanged: onReduceMotionChanged,
            activeThumbColor: colors.primaryBlue,
          ),
        ),
        Divider(height: 1, color: colors.divider, indent: 20, endIndent: 20),
        _OptionRow(
          colors: colors,
          data: const _DisplayOptionRowData(
            icon: Icons.contrast_rounded,
            title: 'High Contrast',
            subtitle: 'Increase contrast for better visibility',
          ),
          trailing: Switch(
            value: highContrast,
            onChanged: onHighContrastChanged,
            activeThumbColor: colors.primaryBlue,
          ),
        ),
        Divider(height: 1, color: colors.divider, indent: 20, endIndent: 20),
        _OptionRow(
          colors: colors,
          data: const _DisplayOptionRowData(
            icon: Icons.grid_view_rounded,
            title: 'Compact Mode',
            subtitle: 'Show more content in less space',
          ),
          trailing: Switch(
            value: compactMode,
            onChanged: onCompactModeChanged,
            activeThumbColor: colors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.colors,
    required this.data,
    required this.trailing,
  });

  final AppColorsExt colors;
  final _DisplayOptionRowData data;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, size: 20, color: colors.primaryBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(color: colors.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// E. Preview Section
/// -----------------------------------------------------------------------

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          colors: colors,
          title: 'Preview',
          subtitle: 'See how the app looks with your settings',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.event_note_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Task',
                      style: TextStyle(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Design system implementation',
                      style: TextStyle(
                        color: colors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    color: colors.primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// Standalone preview support
/// -----------------------------------------------------------------------
///
/// This block lets the file run in isolation (e.g. via `flutter run` on
/// this file directly) without requiring the full app's theme setup.
/// In the real app, `AppColorsExt` should come from `app_theme.dart` via
/// `context.appColors`; this fallback mirrors that token surface so the
/// screen compiles and renders standalone for design review.

void main() {
  runApp(const _AppearancePreviewApp());
}

class _AppearancePreviewApp extends StatelessWidget {
  const _AppearancePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        extensions: const [AppColorsExt.light],
      ),
      home: const AppearanceScreen(),
    );
  }
}

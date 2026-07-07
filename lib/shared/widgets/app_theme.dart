import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// MC_SS Smart Scheduler — App Theme
/// -----------------------------------------------------------------------
/// Wraps Flutter's [ColorScheme] with a [ThemeExtension] that carries the
/// extra design tokens from the MC_SS palette guide that don't map cleanly
/// onto Material's built-in slots (AI accent, tonal fills, dividers,
/// gradients, soft "neumorphic-lite" shadows).
///
/// Usage:
///   final tokens = context.appColors;
///   tokens.aiAccent, tokens.success, tokens.softShadow, ...
/// -----------------------------------------------------------------------

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.secondaryBackground,
    required this.divider,
    required this.disabledText,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.aiAccent,
    required this.aiCardGradient,
    required this.primaryGradient,
    required this.splashGradient,
    required this.softShadow,
  });

  /// Tonal fill used for chips, quick-action tiles, input backgrounds.
  final Color secondaryBackground;

  /// Hairline separators between list rows / sections.
  final Color divider;

  /// Text color for disabled controls.
  final Color disabledText;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  /// Accent used exclusively for "AI Suggestions" surfaces.
  final Color aiAccent;

  /// Background gradient for AI suggestion cards.
  final Gradient aiCardGradient;

  /// Primary Blue → Secondary Cyan, used on the FAB / filled buttons.
  final Gradient primaryGradient;

  /// Splash / onboarding background gradient.
  final Gradient splashGradient;

  /// A soft, low-opacity shadow list. Empty in dark mode (glow-free), a
  /// gentle blurred drop shadow in light mode — the "neumorphic-lite" look.
  final List<BoxShadow> softShadow;

  static const light = AppColorsExt(
    secondaryBackground: Color(0xFFEEF4FF),
    divider: Color(0xFFE8EDF5),
    disabledText: Color(0xFFA9B4C5),
    success: Color(0xFF34C759),
    warning: Color(0xFFFFC542),
    error: Color(0xFFFF5A5F),
    info: Color(0xFF4A90E2),
    aiAccent: Color(0xFF6C63FF),
    aiCardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF3F2FF), Color(0xFFEEF5FF)],
    ),
    primaryGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1565FF), Color(0xFF2EC5FF)],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0B1228), Color(0xFF1565FF), Color(0xFF2EC5FF)],
    ),
    softShadow: [
      BoxShadow(
        color: Color(0x140F2D6B), // ~8% Dark Navy
        blurRadius: 24,
        offset: Offset(0, 10),
        spreadRadius: -6,
      ),
      BoxShadow(
        color: Color(0x0A0F2D6B), // ~4% Dark Navy, tight contact shadow
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ],
  );

  static const dark = AppColorsExt(
    secondaryBackground: Color(0xFF1E2A47),
    divider: Color(0xFF26324D),
    disabledText: Color(0xFF7D8CA3),
    success: Color(0xFF4CD964),
    warning: Color(0xFFFFD166),
    error: Color(0xFFFF6B6B),
    info: Color(0xFF64B5F6),
    aiAccent: Color(0xFF8B7CFF),
    aiCardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1B2542), Color(0xFF16213B)],
    ),
    primaryGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF2E7DFF), Color(0xFF3DDCFF)],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0B1228), Color(0xFF2E7DFF), Color(0xFF3DDCFF)],
    ),
    softShadow: [
      BoxShadow(
        color: Color(0x66000000),
        blurRadius: 18,
        offset: Offset(0, 8),
        spreadRadius: -8,
      ),
    ],
  );

  @override
  AppColorsExt copyWith({
    Color? secondaryBackground,
    Color? divider,
    Color? disabledText,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? aiAccent,
    Gradient? aiCardGradient,
    Gradient? primaryGradient,
    Gradient? splashGradient,
    List<BoxShadow>? softShadow,
  }) {
    return AppColorsExt(
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      divider: divider ?? this.divider,
      disabledText: disabledText ?? this.disabledText,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      aiAccent: aiAccent ?? this.aiAccent,
      aiCardGradient: aiCardGradient ?? this.aiCardGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      splashGradient: splashGradient ?? this.splashGradient,
      softShadow: softShadow ?? this.softShadow,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      secondaryBackground:
          Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      aiAccent: Color.lerp(aiAccent, other.aiAccent, t)!,
      aiCardGradient: t < 0.5 ? aiCardGradient : other.aiCardGradient,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      splashGradient: t < 0.5 ? splashGradient : other.splashGradient,
      softShadow: t < 0.5 ? softShadow : other.softShadow,
    );
  }
}

/// Convenience accessor: `context.appColors.aiAccent`
extension AppColorsContext on BuildContext {
  AppColorsExt get appColors =>
      Theme.of(this).extension<AppColorsExt>() ?? AppColorsExt.light;
}

class AppTheme {
  AppTheme._();

  static const _radiusCard = 22.0;
  static const _radiusControl = 16.0;

  static ThemeData get light {
    const primary = Color(0xFF1565FF);
    const secondary = Color(0xFF2EC5FF);
    const background = Color(0xFFF8FAFD);
    const surface = Color(0xFFFFFFFF);
    const primaryText = Color(0xFF1C2434);
    const secondaryText = Color(0xFF6C7A92);
    const error = Color(0xFFFF5A5F);

    final colorScheme = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: const Color(0xFF0F2D6B),
      tertiary: const Color(0xFF6C63FF),
      surface: surface,
      onSurface: primaryText,
      surfaceContainerHighest: const Color(0xFFEEF4FF),
      onSurfaceVariant: secondaryText,
      error: error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      textTheme: _textTheme(primaryText, secondaryText),
      dividerColor: const Color(0xFFE8EDF5),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primaryText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusCard),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEEF4FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusControl),
          borderSide: BorderSide.none,
        ),
      ),
      extensions: const [AppColorsExt.light],
    );
  }

  static ThemeData get dark {
    const primary = Color(0xFF2E7DFF);
    const secondary = Color(0xFF3DDCFF);
    const background = Color(0xFF0B1228);
    const surface = Color(0xFF18233D);
    const primaryText = Color(0xFFF5F7FA);
    const secondaryText = Color(0xFFB7C3D7);
    const error = Color(0xFFFF6B6B);

    final colorScheme = ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: const Color(0xFF0B1228),
      tertiary: const Color(0xFF8B7CFF),
      surface: surface,
      onSurface: primaryText,
      surfaceContainerHighest: const Color(0xFF1E2A47),
      onSurfaceVariant: secondaryText,
      error: error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      textTheme: _textTheme(primaryText, secondaryText),
      dividerColor: const Color(0xFF26324D),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primaryText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusCard),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E2A47),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusControl),
          borderSide: BorderSide.none,
        ),
      ),
      extensions: const [AppColorsExt.dark],
    );
  }

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      headlineSmall: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(color: primaryText, fontSize: 15),
      bodyMedium: TextStyle(color: secondaryText, fontSize: 14),
      bodySmall: TextStyle(color: secondaryText, fontSize: 12),
      labelLarge: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}

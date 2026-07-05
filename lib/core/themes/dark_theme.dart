import 'package:flutter/material.dart';

class AppDarkTheme {
  AppDarkTheme._();

  // ==========================
  // Color Palette
  // ==========================

  static const Color primary = Color(0xFF2E7DFF);
  static const Color secondary = Color(0xFF3DDCFF);
  static const Color tertiary = Color(0xFF8B7CFF); // AI Accent

  static const Color background = Color(0xFF0B1228);
  static const Color surface = Color(0xFF121A2E);
  static const Color card = Color(0xFF18233D);

  static const Color divider = Color(0xFF26324D);

  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFFB7C3D7);
  static const Color disabled = Color(0xFF7D8CA3);

  static const Color success = Color(0xFF4CD964);
  static const Color warning = Color(0xFFFFD166);
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF64B5F6);

  // ==========================
  // Gradients
  // ==========================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565FF), Color(0xFF2EC5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0B1228), Color(0xFF1565FF), Color(0xFF2EC5FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient aiCardGradient = LinearGradient(
    colors: [Color(0xFFF3F2FF), Color(0xFFEEF5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==========================
  // Theme
  // ==========================

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: background,
      canvasColor: background,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      dividerTheme: const DividerThemeData(color: divider, thickness: 1),

      iconTheme: const IconThemeData(color: textPrimary, size: 24),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondary,
          side: const BorderSide(color: secondary, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: secondary),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: tertiary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: disabled,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        hintStyle: const TextStyle(color: textSecondary),

        labelStyle: const TextStyle(color: textSecondary),

        prefixIconColor: secondary,
        suffixIconColor: textSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: divider),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 2),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: const TextStyle(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: secondary,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(secondary),
        trackColor: WidgetStateProperty.all(primary.withValues(alpha: 0.35)),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: disabled),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: textSecondary),
      ),
    );
  }
}

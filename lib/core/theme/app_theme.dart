import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brand,
        secondary: AppColors.brand2,
        surface: AppColors.panel,
        error: AppColors.danger,
        onPrimary: Color(0xFF06250F), // Extracted from proto .btn color
        onSurface: AppColors.text,
      ),
      fontFamily:
          'ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.text, fontSize: 13),
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 14),
        titleLarge: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.01,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        labelSmall: TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      dividerColor: AppColors.line,
      cardTheme: const CardThemeData(
        color: AppColors.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: const Color(0xFF06250F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
    );
  }

  // Returns the complex gradients for Scaffold background
  static BoxDecoration get appBackgroundDecoration {
    return const BoxDecoration(
      color: AppColors.bg,
      // We will handle the radial gradients via a custom Stack in the layout
      // as flutter doesn't easily compose radial gradients like CSS without custom painters.
    );
  }
}

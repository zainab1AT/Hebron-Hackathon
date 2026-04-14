import 'package:flutter/material.dart';

// ── Rafeeq Light Theme – Color Tokens ──────────────────────────────────────
//
// Background  : #F7F8FA (cool off-white)
// Surface     : #FFFFFF (pure white cards/sheets)
// SurfaceVar  : #F0F1F4 (input fills, secondary surfaces)
// Primary     : #0A9B7A (evolved teal – Rafeeq brand)
// PrimaryDark : #07795E (pressed/dark variant)
// PrimaryLight: #E6F5F0 (tinted backgrounds)
// Secondary   : #3B82F6 (blue – info, links, driver)
// Warning     : #F59E0B (amber)
// Error       : #EF4444 (red)
// Success     : #10B981 (green confirmations)
// TextPrimary : #1A1D26 (near-black, high contrast)
// TextSecondary: #6B7280 (gray-500, readable)
// TextHint    : #9CA3AF (gray-400, placeholders)
// Divider     : #E5E7EB (gray-200)
// CardBorder  : #E5E7EB
//
// Report semantic:
// Traffic     : #F59E0B (amber)
// Checkpoint  : #3B82F6 (blue)
// RoadClosed  : #EF4444 (red)
//
// Role semantic:
// Passenger   : #0A9B7A (primary teal)
// Driver      : #3B82F6 (blue)
// DriverOnDuty: #10B981 (green)
// ────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // ── Surfaces ─────────────────────────────────────────────────────────────
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0F1F4);

  // ── Brand ────────────────────────────────────────────────────────────────
  static const primary = Color(0xFF0A9B7A);
  static const primaryDark = Color(0xFF07795E);
  static const primaryLight = Color(0xFFE6F5F0);
  static const secondary = Color(0xFF3B82F6);
  static const secondaryLight = Color(0xFFEFF6FF);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFFFBEB);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEF2F2);
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFECFDF5);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1A1D26);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders / Dividers ───────────────────────────────────────────────────
  static const divider = Color(0xFFE5E7EB);
  static const cardBorder = Color(0xFFE5E7EB);

  // ── Report type colours ──────────────────────────────────────────────────
  static const traffic = Color(0xFFF59E0B);
  static const checkpoint = Color(0xFF3B82F6);
  static const roadClosed = Color(0xFFEF4444);

  // ── Role colours ─────────────────────────────────────────────────────────
  static const passenger = Color(0xFF0A9B7A);
  static const driver = Color(0xFF3B82F6);
  static const driverOnDuty = Color(0xFF10B981);

  // ── Map overlay (semi-transparent for controls on map) ───────────────────
  static const mapOverlay = Color(0xF2FFFFFF); // 95% white
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.textOnPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: AppColors.textOnPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          hintStyle: const TextStyle(color: AppColors.textHint),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600),
          titleLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 15),
          bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          bodySmall: TextStyle(color: AppColors.textHint, fontSize: 11),
          labelLarge: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.textHint),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primaryLight
                  : AppColors.surfaceVariant),
        ),
        useMaterial3: true,
      );

  // Keep dark theme available for preference (not used by default now)
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        useMaterial3: true,
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the financial aid distribution application.
/// Implements "Trust Foundation" color palette with "Institutional Clarity" design approach.
class AppTheme {
  AppTheme._();

  // Trust Foundation Color Palette
  static const Color primaryLight =
      Color(0xFF1B365D); // Deep institutional blue
  static const Color secondaryLight = Color(0xFF2E7D32); // Success green
  static const Color accentLight =
      Color(0xFFFF6B35); // Warm orange for attention
  static const Color surfaceLight = Color(0xFFFAFBFC); // Clean background
  static const Color surfaceVariantLight =
      Color(0xFFF1F3F5); // Subtle card backgrounds
  static const Color onSurfaceLight = Color(0xFF1C1C1E); // High contrast text
  static const Color onSurfaceVariantLight =
      Color(0xFF6B7280); // Secondary text
  static const Color errorLight = Color(0xFFDC2626); // Clear error indication
  static const Color warningLight = Color(0xFFF59E0B); // Caution states
  static const Color successLight = Color(0xFF059669); // Transaction completion

  // Dark theme variants (maintaining trust while adapting for dark mode)
  static const Color primaryDark =
      Color(0xFF4A90E2); // Lighter blue for dark backgrounds
  static const Color secondaryDark =
      Color(0xFF4CAF50); // Adjusted green for dark mode
  static const Color accentDark =
      Color(0xFFFF8A65); // Softer orange for dark mode
  static const Color surfaceDark = Color(0xFF121212); // Material dark surface
  static const Color surfaceVariantDark =
      Color(0xFF1E1E1E); // Dark card backgrounds
  static const Color onSurfaceDark =
      Color(0xFFE1E1E1); // High contrast text for dark
  static const Color onSurfaceVariantDark =
      Color(0xFFB0B0B0); // Secondary text for dark
  static const Color errorDark = Color(0xFFEF5350); // Error for dark mode
  static const Color warningDark = Color(0xFFFFB74D); // Warning for dark mode
  static const Color successDark = Color(0xFF66BB6A); // Success for dark mode

  // Additional semantic colors
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1FFFFFFF);

  /// Light theme optimized for financial aid distribution
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: Colors.white,
          primaryContainer: primaryLight.withAlpha(26),
          onPrimaryContainer: primaryLight,
          secondary: secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: secondaryLight.withAlpha(26),
          onSecondaryContainer: secondaryLight,
          tertiary: accentLight,
          onTertiary: Colors.white,
          tertiaryContainer: accentLight.withAlpha(26),
          onTertiaryContainer: accentLight,
          error: errorLight,
          onError: Colors.white,
          errorContainer: errorLight.withAlpha(26),
          onErrorContainer: errorLight,
          surface: surfaceLight,
          onSurface: onSurfaceLight,
          surfaceContainerHighest: surfaceVariantLight,
          onSurfaceVariant: onSurfaceVariantLight,
          outline: dividerLight,
          outlineVariant: dividerLight.withAlpha(128),
          shadow: shadowLight,
          scrim: Colors.black54,
          inverseSurface: surfaceDark,
          onInverseSurface: onSurfaceDark,
          inversePrimary: primaryDark),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      dividerColor: dividerLight,

      // AppBar theme for institutional trust
      appBarTheme: AppBarTheme(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 2.0,
          shadowColor: shadowLight,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.15),
          iconTheme: const IconThemeData(color: Colors.white, size: 24),
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 24)),

      // Card theme for progressive disclosure
      cardTheme: CardThemeData(
          color: cardLight,
          elevation: 2.0,
          shadowColor: shadowLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for role-adaptive navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: onSurfaceVariantLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // FAB theme for primary actions
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentLight,
          foregroundColor: Colors.white,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),

      // Button themes for clear action hierarchy
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryLight,
              elevation: 2.0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: primaryLight, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),

      // Typography using Inter font family
      textTheme: _buildTextTheme(isLight: true),

      // Input decoration for form clarity
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceLight,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: dividerLight, width: 1)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: dividerLight, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: primaryLight, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorLight, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorLight, width: 2)),
          labelStyle: GoogleFonts.inter(color: onSurfaceVariantLight, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: onSurfaceVariantLight.withAlpha(153), fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorLight, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch theme for settings
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey[300];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(128);
        }
        return Colors.grey[300];
      })),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: const BorderSide(color: dividerLight, width: 2)),

      // Radio theme
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return onSurfaceVariantLight;
      })),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryLight, linearTrackColor: dividerLight, circularTrackColor: dividerLight),

      // Slider theme
      sliderTheme: SliderThemeData(activeTrackColor: primaryLight, thumbColor: primaryLight, overlayColor: primaryLight.withAlpha(51), inactiveTrackColor: dividerLight, valueIndicatorColor: primaryLight),

      // Tab bar theme for navigation
      tabBarTheme: TabBarThemeData(labelColor: primaryLight, unselectedLabelColor: onSurfaceVariantLight, indicatorColor: primaryLight, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Tooltip theme
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: onSurfaceLight.withAlpha(230), borderRadius: BorderRadius.circular(4)), textStyle: GoogleFonts.inter(color: surfaceLight, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),

      // SnackBar theme for feedback
      snackBarTheme: SnackBarThemeData(backgroundColor: onSurfaceLight, contentTextStyle: GoogleFonts.inter(color: surfaceLight, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: accentLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),

      // Dialog theme
      dialogTheme: DialogThemeData(backgroundColor: cardLight, elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: onSurfaceLight), contentTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceLight)),

      // Bottom sheet theme for contextual actions
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: cardLight, elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)))));

  /// Dark theme maintaining trust foundation principles
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: Colors.black,
          primaryContainer: primaryDark.withAlpha(51),
          onPrimaryContainer: primaryDark,
          secondary: secondaryDark,
          onSecondary: Colors.black,
          secondaryContainer: secondaryDark.withAlpha(51),
          onSecondaryContainer: secondaryDark,
          tertiary: accentDark,
          onTertiary: Colors.black,
          tertiaryContainer: accentDark.withAlpha(51),
          onTertiaryContainer: accentDark,
          error: errorDark,
          onError: Colors.black,
          errorContainer: errorDark.withAlpha(51),
          onErrorContainer: errorDark,
          surface: surfaceDark,
          onSurface: onSurfaceDark,
          surfaceContainerHighest: surfaceVariantDark,
          onSurfaceVariant: onSurfaceVariantDark,
          outline: dividerDark,
          outlineVariant: dividerDark.withAlpha(128),
          shadow: shadowDark,
          scrim: Colors.black87,
          inverseSurface: surfaceLight,
          onInverseSurface: onSurfaceLight,
          inversePrimary: primaryLight),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      dividerColor: dividerDark,

      // AppBar theme for dark mode
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: onSurfaceDark,
          elevation: 2.0,
          shadowColor: shadowDark,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurfaceDark,
              letterSpacing: 0.15),
          iconTheme: IconThemeData(color: onSurfaceDark, size: 24),
          actionsIconTheme: IconThemeData(color: onSurfaceDark, size: 24)),

      // Card theme for dark mode
      cardTheme: CardThemeData(
          color: cardDark,
          elevation: 2.0,
          shadowColor: shadowDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for dark mode
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: onSurfaceVariantDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // FAB theme for dark mode
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentDark,
          foregroundColor: Colors.black,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),

      // Button themes for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: primaryDark,
              elevation: 2.0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: primaryDark, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),

      // Typography for dark mode
      textTheme: _buildTextTheme(isLight: false),

      // Input decoration for dark mode
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceDark,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: dividerDark, width: 1)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: dividerDark, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: primaryDark, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorDark, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorDark, width: 2)),
          labelStyle: GoogleFonts.inter(color: onSurfaceVariantDark, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: onSurfaceVariantDark.withAlpha(153), fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorDark, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch theme for dark mode
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey[600];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(128);
        }
        return Colors.grey[600];
      })),

      // Checkbox theme for dark mode
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.black),
          side: const BorderSide(color: dividerDark, width: 2)),

      // Radio theme for dark mode
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return onSurfaceVariantDark;
      })),

      // Progress indicator theme for dark mode
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryDark, linearTrackColor: dividerDark, circularTrackColor: dividerDark),

      // Slider theme for dark mode
      sliderTheme: SliderThemeData(activeTrackColor: primaryDark, thumbColor: primaryDark, overlayColor: primaryDark.withAlpha(51), inactiveTrackColor: dividerDark, valueIndicatorColor: primaryDark),

      // Tab bar theme for dark mode
      tabBarTheme: TabBarThemeData(labelColor: primaryDark, unselectedLabelColor: onSurfaceVariantDark, indicatorColor: primaryDark, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Tooltip theme for dark mode
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: onSurfaceDark.withAlpha(230), borderRadius: BorderRadius.circular(4)), textStyle: GoogleFonts.inter(color: surfaceDark, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),

      // SnackBar theme for dark mode
      snackBarTheme: SnackBarThemeData(backgroundColor: onSurfaceDark, contentTextStyle: GoogleFonts.inter(color: surfaceDark, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: accentDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),

      // Dialog theme for dark mode
      dialogTheme: DialogThemeData(backgroundColor: cardDark, elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: onSurfaceDark), contentTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceDark)),

      // Bottom sheet theme for dark mode
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: cardDark, elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)))));

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? onSurfaceLight : onSurfaceDark;
    final Color textMediumEmphasis =
        isLight ? onSurfaceVariantLight : onSurfaceVariantDark;
    final Color textDisabled = isLight
        ? onSurfaceVariantLight.withAlpha(153)
        : onSurfaceVariantDark.withAlpha(153);

    return TextTheme(
        // Display styles for large headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: textHighEmphasis,
            letterSpacing: -0.25),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0),

        // Headline styles for section headers
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0),

        // Title styles for card headers and important text
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textHighEmphasis,
            letterSpacing: 0),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textHighEmphasis,
            letterSpacing: 0.15),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textHighEmphasis,
            letterSpacing: 0.1),

        // Body styles for main content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0.5),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0.25),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMediumEmphasis,
            letterSpacing: 0.4),

        // Label styles for buttons and form labels
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textHighEmphasis,
            letterSpacing: 0.1),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMediumEmphasis,
            letterSpacing: 0.5),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textDisabled,
            letterSpacing: 0.5));
  }

  /// Data text style using JetBrains Mono for transaction data
  static TextStyle dataTextStyle(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: isLight ? onSurfaceLight : onSurfaceDark,
        letterSpacing: 0);
  }

  /// Helper method to get semantic colors
  static Color getSemanticColor(String type, {required bool isLight}) {
    switch (type.toLowerCase()) {
      case 'success':
        return isLight ? successLight : successDark;
      case 'warning':
        return isLight ? warningLight : warningDark;
      case 'error':
        return isLight ? errorLight : errorDark;
      case 'accent':
        return isLight ? accentLight : accentDark;
      default:
        return isLight ? primaryLight : primaryDark;
    }
  }
}

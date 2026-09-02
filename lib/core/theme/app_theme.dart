import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Godrej industrial brand direction ---
  // Deep green and graphite feel more like industrial solutions than boutique retail.
  static const Color godrejRuby = Color(0xFF1E4D3B);
  static const Color godrejBlue = Color(0xFF2F3E4E);
  static const Color godrejGreen = Color(0xFFB68B4A);

  // --- Brand Dark Tokens ---
  static const Color godrejRubyLuminous = Color(0xFF2B6C52);
  static const Color godrejBlueLuminous = Color(0xFF4C647E);
  static const Color godrejGreenLuminous = Color(0xFFD6A35D);

  // Light Theme Surfaces
  static const Color lightBg = Color(0xFFF3F5F1);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVar = Color(0xFFEDF1EE);
  static const Color lightOutline = Color(0xFFD8DED9);
  static const Color lightText = Color(0xFF17242B);
  static const Color lightMuted = Color(0xFF586772);

  // Dark Theme Surfaces
  static const Color darkBg = Color(0xFF0E1417);
  static const Color darkSurface = Color(0xFF18222A);
  static const Color darkSurfaceVar = Color(0xFF232E36);
  static const Color darkOutline = Color(0xFF34424D);

  // ---------------- LIGHT THEME ----------------
  static ThemeData lightTheme() {
    final colorScheme = const ColorScheme.light(
      primary: godrejRuby,
      secondary: godrejBlue,
      tertiary: godrejGreen,
      surface: lightSurface,
      surfaceContainerHighest: lightSurfaceVar,
      error: Color(0xFFD92D20),
      outline: lightOutline,
    );

    final baseText = GoogleFonts.interTextTheme().apply(
      bodyColor: lightText,
      displayColor: lightText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: lightText,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightText,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightSurfaceVar,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      textTheme: baseText.copyWith(
        displayLarge: baseText.displayLarge?.copyWith(
          fontSize: 34,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontSize: 14,
          color: lightMuted,
        ),
        bodySmall: baseText.bodySmall?.copyWith(
          fontSize: 12,
          color: lightMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: godrejRuby,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lightOutline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceVar,
        selectedColor: godrejRuby.withAlpha(31), // ~12% opacity
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ---------------- DARK THEME ----------------
  static ThemeData darkTheme() {
    final colorScheme = const ColorScheme.dark(
      primary: godrejRubyLuminous,
      secondary: godrejBlueLuminous,
      tertiary: godrejGreenLuminous,
      surface: darkSurface,
      surfaceContainerHighest: darkSurfaceVar,
      error: Color(0xFFFF5252),
      outline: darkOutline,
    );

    final baseText = GoogleFonts.interTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textTheme: baseText.copyWith(
        displayLarge: baseText.displayLarge?.copyWith(
          fontSize: 34,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontSize: 14,
          color: Colors.white70,
        ),
        bodySmall: baseText.bodySmall?.copyWith(
          fontSize: 12,
          color: Colors.white54,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: godrejRubyLuminous,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 4,
          shadowColor: godrejRubyLuminous.withAlpha(100), // ~40% opacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withAlpha(20)), // ~8% opacity
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceVar,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(10), // ~4% opacity
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withAlpha(31),
          ), // ~12% opacity
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(31)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: godrejRubyLuminous, width: 1.5),
        ),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVar,
        selectedColor: godrejRubyLuminous.withAlpha(64), // ~25% opacity
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withAlpha(20)),
        ),
      ),
    );
  }
}

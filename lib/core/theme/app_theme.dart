import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Official Godrej Tri-Color Script Palette
  static const Color godrejRuby = Color(
    0xFFBE0959,
  ); // Magenta/Ruby (Bottom wave)
  static const Color godrejBlue = Color(0xFF0089CF); // Azure Blue (Middle wave)
  static const Color godrejGreen = Color(0xFF75B833); // Leaf Green (Top wave)

  // Light Theme Surfaces
  static const Color lightBg = Color(0xFFF7F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVar = Color(0xFFEEF2F8);
  static const Color lightOutline = Color(0xFFD8DFEB);
  static const Color lightText = Color(0xFF131A26);
  static const Color lightMuted = Color(0xFF5A6678);

  // Dark Theme Surfaces (High-Contrast & Clean)
  static const Color darkBg = Color(0xFF0C1017);
  static const Color darkSurface = Color(0xFF161E2E);
  static const Color darkSurfaceVar = Color(0xFF212B3F);
  static const Color darkOutline = Color(0xFF2C3B55);

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

    final baseText = GoogleFonts.notoSansGurmukhiTextTheme().apply(
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
        titleTextStyle: GoogleFonts.notoSansGurmukhi(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightText,
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
        selectedColor: godrejRuby.withAlpha(31),
        labelStyle: GoogleFonts.notoSansGurmukhi(
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = const ColorScheme.dark(
      primary: godrejRuby,
      secondary: godrejBlue,
      tertiary: godrejGreen,
      surface: darkSurface,
      surfaceContainerHighest: darkSurfaceVar,
      error: Color(0xFFFF5252),
      outline: darkOutline,
    );

    final baseText = GoogleFonts.notoSansGurmukhiTextTheme().apply(
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
        titleTextStyle: GoogleFonts.notoSansGurmukhi(
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
          color: Colors.white60,
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
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: darkOutline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVar,
        selectedColor: godrejRuby.withAlpha(64),
        labelStyle: GoogleFonts.notoSansGurmukhi(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

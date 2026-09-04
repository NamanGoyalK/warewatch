import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ink for actions. Surfaces stay cool and quiet.
  static const Color ink = Color(0xFF1A1A1A);
  static const Color steel = Color(0xFF5C6570);
  static const Color brass = Color(0xFF8A8478);
  static const Color phosphor = Color(0xFF7CBA4A);

  static const Color inkLuminous = Color(0xFFF2F2F2);
  static const Color steelLuminous = Color(0xFF9AA3AD);
  static const Color brassLuminous = Color(0xFFB0AAA0);

  static const Color lightBg = Color(0xFFF6F6F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVar = Color(0xFFEEEEEE);
  static const Color lightOutline = Color(0xFFD8D8D8);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightMuted = Color(0xFF6B6B6B);

  static const Color darkBg = Color(0xFF0E0E0E);
  static const Color darkSurface = Color(0xFF171717);
  static const Color darkSurfaceVar = Color(0xFF222222);
  static const Color darkOutline = Color(0xFF3A3A3A);

  static ThemeData lightTheme() {
    const colorScheme = ColorScheme.light(
      primary: ink,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8E8E8),
      onPrimaryContainer: ink,
      secondary: steel,
      onSecondary: Colors.white,
      tertiary: brass,
      onTertiary: Colors.white,
      surface: lightSurface,
      onSurface: lightText,
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
          backgroundColor: ink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightOutline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: ink, width: 1.5),
        ),
        hintStyle: const TextStyle(color: lightMuted),
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
        selectedColor: ink.withAlpha(31),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: inkLuminous,
      onPrimary: Color(0xFF111111),
      primaryContainer: Color(0xFF2A2A2A),
      onPrimaryContainer: inkLuminous,
      secondary: steelLuminous,
      onSecondary: Color(0xFF111111),
      tertiary: brassLuminous,
      onTertiary: Color(0xFF111111),
      surface: darkSurface,
      onSurface: Colors.white,
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
          backgroundColor: inkLuminous,
          foregroundColor: const Color(0xFF111111),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
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
          side: BorderSide(color: Colors.white.withAlpha(20)),
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
        fillColor: Colors.white.withAlpha(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(31)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(31)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: inkLuminous, width: 1.5),
        ),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVar,
        selectedColor: inkLuminous.withAlpha(40),
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

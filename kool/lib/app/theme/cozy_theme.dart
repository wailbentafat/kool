import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CozyColors {
  // Warm, soft palette
  static const Color background = Color(0xFFFDF6F0); // Warm off-white
  static const Color primary = Color(0xFFE6ACA0); // Soft terracotta/peach
  static const Color primaryDark = Color(0xFFD48A7D);
  static const Color secondary = Color(0xFF8BB1B1); // Soft teal
  static const Color secondaryDark = Color(0xFF6A9191);
  static const Color textMain = Color(0xFF4A4A4A); // Soft black
  static const Color textSub = Color(0xFF757575);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAF9F6);
  static const Color success = Color(0xFFA3D9B5);
  static const Color error = Color(0xFFE5989B);
  static const Color warning = Color(0xFFF4A261); // Soft Orange
  static const Color accent = Color(0xFFF4D35E); // Muted Gold

  // Dark Palette
  static const Color backgroundDark = Color(0xFF1A1A2E); // Deep Midnight Blue
  static const Color surfaceDark = Color(0xFF16213E); // Dark Blue Grey
  static const Color cardBgDark = Color(0xFF222831); // Dark Grey
  static const Color textMainDark = Color(0xFFE8E8E8); // Off-White
  static const Color textSubDark = Color(0xFFB0B0B0); // Light Grey
}

class CozyTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: CozyColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CozyColors.primary,
        background: CozyColors.background,
        surface: CozyColors.surface,
        brightness: Brightness.light,
        error: CozyColors.error,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: CozyColors.textMain,
        displayColor: CozyColors.textMain,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CozyColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: CozyColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: CozyColors.textMain),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CozyColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: CozyColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CozyColors.primary, // Keep primary playful
        background: CozyColors.backgroundDark,
        surface: CozyColors.surfaceDark,
        brightness: Brightness.dark,
        error: CozyColors.error,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: CozyColors.textMainDark,
        displayColor: CozyColors.textMainDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CozyColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: CozyColors.textMainDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: CozyColors.textMainDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CozyColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

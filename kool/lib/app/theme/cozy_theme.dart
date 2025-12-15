import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/mode_detection/models/learning_mode.dart';

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
  // --- Standard Colors ---
  static ThemeData get light => getTheme(LearningMode.normal, ThemeMode.light);
  static ThemeData get dark => getTheme(LearningMode.normal, ThemeMode.dark);

  // --- Adaptive Theme Generation ---
  static ThemeData getTheme(LearningMode mode, ThemeMode themeMode) {
    // 1. Determine Colors based on Mode & Brightness
    final isDark = themeMode == ThemeMode.dark;

    Color background;
    Color surface;
    Color primary;
    Color text;

    if (mode == LearningMode.adhd) {
      // ADHD: Calm, Cool colors (Greens/Blues) to reduce excitation
      background = isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF1F5F9); // Slate
      surface = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);
      primary = const Color(0xFF38BDF8); // Sky Blue (Calming)
      text = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF334155);
    } else if (mode == LearningMode.dyslexia) {
      // Dyslexia: Warm/Off-white/Sepia to reduce visual stress
      // Avoid pure white.
      background = isDark
          ? const Color(0xFF2C2522)
          : const Color(0xFFFDF6E3); // Solarized Light/Dark basis
      surface = isDark ? const Color(0xFF241D1A) : const Color(0xFFEEE8D5);
      primary = const Color(0xFFD33682); // Magenta (Contrast) or Orange
      text = isDark
          ? const Color(0xFFFDF6E3)
          : const Color(0xFF433B32); // Lowish contrast black
    } else {
      // Normal: Cozy and Warm
      background = isDark ? CozyColors.backgroundDark : CozyColors.background;
      surface = isDark ? CozyColors.surfaceDark : CozyColors.surface;
      primary = CozyColors.primary;
      text = isDark ? CozyColors.textMainDark : CozyColors.textMain;
    }

    // 2. Determine Typography
    TextTheme textTheme;
    if (mode == LearningMode.dyslexia) {
      // OpenDyslexic isn't in GoogleFonts efficiently, but Lexend or Comic Neue are good subs.
      // User agreed to Lexend.
      textTheme = GoogleFonts.lexendTextTheme();
    } else if (mode == LearningMode.adhd) {
      // Clean, sans-serif, no distraction.
      textTheme = GoogleFonts.robotoTextTheme();
    } else {
      // Playful/Round
      textTheme = GoogleFonts.outfitTextTheme();
    }

    // Apply colors to text theme
    textTheme = textTheme.apply(bodyColor: text, displayColor: text);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        background: background,
        surface: surface,
        brightness: isDark ? Brightness.dark : Brightness.light,
        error: CozyColors.error,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: text,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: mode == LearningMode.adhd ? 0 : 2, // Flat for ADHD
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              mode == LearningMode.dyslexia ? 8 : 16,
            ), // Less round for dyslexia?
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

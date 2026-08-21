import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CoffeeGuard's visual identity: warm coffee browns paired with a fresh
/// leaf green, on a soft cream background. Kept intentionally minimal —
/// two accent colors, generous whitespace, rounded surfaces.
class AppColors {
  static const Color coffeeBrown = Color(0xFF4A2E1E);
  static const Color coffeeBrownLight = Color(0xFF7A5240);
  static const Color leafGreen = Color(0xFF4C7A4C);
  static const Color leafGreenLight = Color(0xFFE7F0E3);
  static const Color cream = Color(0xFFFBF7F2);
  static const Color warnAmber = Color(0xFFC97B2E);
  static const Color errorRed = Color(0xFFB3413B);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.leafGreen,
      brightness: Brightness.light,
      surface: AppColors.cream,
    ),
    scaffoldBackgroundColor: AppColors.cream,
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
    displaySmall: GoogleFonts.dmSerifDisplay(
      fontSize: 30,
      color: AppColors.coffeeBrown,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      color: AppColors.coffeeBrown,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.coffeeBrown),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.leafGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.coffeeBrown,
        side: const BorderSide(color: AppColors.coffeeBrownLight),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
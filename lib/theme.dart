import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFCC2D30);
  static const Color red = Color(0xFFCC2D30);
  static const Color error = Color(0xFFF44336);
  static const Color textBoldHeader = Color(0xFF680002);

  // Background gradient colors from Figma
  static const List<Color> gradientColors = [
    Color(0xFFC85255), // 0%
    Color(0xFFD4787C), // 6.17%
    Color(0xFFE1ABAE), // 13.46%
    Color(0xFFE8C3C4), // 19.53%
    Color(0xFFF2CDD3), // 27.59%
    Color(0xFFF0CED2), // 40.75%
    Color(0xFFEAD1D0), // 65.11%
    Color(0xFFF2E4E6), // 100%
  ];

  static const List<double> gradientStops = [
    0.0,
    0.0617,
    0.1346,
    0.1953,
    0.2759,
    0.4075,
    0.6511,
    1.0,
  ];

  // Glassmorphism card background (70% white)
  static const Color cardBg = Color(0xB2FFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF121212);
  static const Color textSecondary = Color(0xFF6A6A6A);
}

class AppTextStyles {
  // Heading - Roboto Bold 20px (matching Figma)
  static TextStyle heading1 = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body - Roboto Regular 10px (matching Figma body text)
  static TextStyle bodyText = GoogleFonts.roboto(
    fontSize: 12, // Increased slightly for better readability than 10px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

class AppTheme {
  // Tema Global Aplikasi
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        bodyLarge: AppTextStyles.bodyText,
        bodyMedium: AppTextStyles.bodyMedium,
        labelSmall: AppTextStyles.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      useMaterial3: true,
    );
  }
}

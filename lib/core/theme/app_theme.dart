import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryDarkGreen,
        secondary: AppColors.orange,
        surface: AppColors.white,
        background: AppColors.lightGray,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.largeHeading(),
        headlineMedium: AppTextStyles.sectionHeading(),
        titleLarge: AppTextStyles.projectName(),
        bodyLarge: AppTextStyles.bodyText(),
        bodyMedium: AppTextStyles.description(),
        labelLarge: AppTextStyles.buttonText(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text style constants for consistent typography
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // Large Headings
  static TextStyle largeHeading({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: 32,
      fontWeight: weight ?? FontWeight.bold,
      color: color ?? AppColors.textDarkGreen,
      height: 1.2,
    );
  }

  // Section Headings
  static TextStyle sectionHeading({
    Color? color,
  }) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textDarkGreen,
      height: 1.3,
    );
  }

  // Project Name
  static TextStyle projectName({
    Color? color,
  }) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textWhite,
      height: 1.3,
    );
  }

  // Body Text
  static TextStyle bodyText({
    Color? color,
    double? fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textBlack,
      height: 1.5,
    );
  }

  // Description Text
  static TextStyle description({
    Color? color,
  }) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textWhite,
      height: 1.5,
    );
  }

  // Button Text
  static TextStyle buttonText({
    Color? color,
  }) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textWhite,
    );
  }

  // Label Text
  static TextStyle label({
    Color? color,
    double? fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textWhite,
    );
  }

  // Small Text
  static TextStyle small({
    Color? color,
  }) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textGray,
    );
  }
}

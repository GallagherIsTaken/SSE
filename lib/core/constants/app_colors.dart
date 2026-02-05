import 'package:flutter/material.dart';

/// App color constants matching the design
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primaryDarkGreen = Color(0xFF013235); // Header, overlays, nav bar
  static const Color secondaryDarkGreen = Color(0xFF022322); // Alternative dark green
  
  // Accent Colors
  static const Color yellow = Color(0xFFFFD700); // SSF logo accents
  static const Color orange = Color(0xFFF68928); // Active states, buttons, featured tags
  static const Color orangeAlternative = Color(0xFFF68928); // Alternative orange
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFDE7); // Cream/beige background color
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure white for text/icons
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF424242);
  
  // Text Colors
  static const Color textDarkGreen = primaryDarkGreen;
  static const Color textOrange = orange;
  static const Color textWhite = pureWhite; // Pure white for text on dark backgrounds
  static const Color textBlack = black;
  static const Color textGray = darkGray;
}

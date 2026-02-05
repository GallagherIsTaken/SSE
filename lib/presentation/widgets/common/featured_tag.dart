import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Featured tag widget for project cards
class FeaturedTag extends StatelessWidget {
  const FeaturedTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: const Text(
        AppStrings.featured,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/feature_model.dart';

/// Feature list item widget for hero banner
class FeatureListItem extends StatelessWidget {
  final FeatureModel feature;

  const FeatureListItem({
    super.key,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          feature.icon,
          color: AppColors.white,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          feature.name,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

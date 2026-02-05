import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// "Finding The Right Home For You" section
class FindingHomeSection extends StatelessWidget {
  const FindingHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      // Center the whole heading block
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.largeHeading(),
          children: [
            TextSpan(
              text: AppStrings.findingTheRightHome,
              style: AppTextStyles.largeHeading(
                color: AppColors.textDarkGreen,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: AppStrings.homeText,
              style: AppTextStyles.largeHeading(
                color: AppColors.textOrange,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: AppStrings.forYou,
              style: AppTextStyles.largeHeading(
                color: AppColors.textDarkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

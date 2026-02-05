import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// App header widget matching the design
class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMailTap;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.title = AppStrings.home,
    this.onMailTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Increased height to match design - adjust this value to change header height
      decoration: const BoxDecoration(
        // Header color stays as primary per design
        color: AppColors.primaryDarkGreen, // #013235
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo and text
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              // TODO: Replace with your actual logo image
              // Place your logo in: assets/icons/logo.png or logo.svg
              Image.asset(
                'assets/icons/logo.png', // TODO: Add your logo image here
                height: 50, // Adjust this value to change logo size
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: Show app name if logo not found
                  return const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: AppColors.textWhite, // Pure white for fallback text
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              // "Sumber Sentuhan Emas" text (white on dark green header)
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.textWhite, // Pure white for text on dark header
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Right: Action icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.mail_outline,
                  color: AppColors.textWhite, // Pure white for icons on dark header
                ),
                onPressed: onMailTap ?? () {},
                tooltip: 'Mail',
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textWhite, // Pure white for icons on dark header
                ),
                onPressed: onProfileTap ?? () {},
                tooltip: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

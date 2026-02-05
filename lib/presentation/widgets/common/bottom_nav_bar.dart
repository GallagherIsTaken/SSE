import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/navigation_provider.dart';

/// Custom bottom navigation bar matching the design (Riverpod)
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.primaryDarkGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: AppStrings.home,
            index: 0,
            isActive: currentIndex == 0,
            onTap: () => navNotifier.setCurrentIndex(0),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.business,
            label: AppStrings.projects,
            index: 1,
            isActive: currentIndex == 1,
            onTap: () => navNotifier.setCurrentIndex(1),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.chat_bubble_outline,
            label: AppStrings.contact,
            index: 2,
            isActive: currentIndex == 2,
            onTap: () => navNotifier.setCurrentIndex(2),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.info_outline,
            label: AppStrings.aboutUs,
            index: 3,
            isActive: currentIndex == 3,
            onTap: () => navNotifier.setCurrentIndex(3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.orange : AppColors.white;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

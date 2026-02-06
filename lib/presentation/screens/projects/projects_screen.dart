import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';
import '../../providers/project_provider.dart';
import '../project_detail/project_detail_screen.dart';
import '../../widgets/projects/project_highlight_card.dart';

/// Full-screen Projects page (if you ever want a dedicated route).
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ProjectsTabContent(),
      ),
    );
  }
}

/// Reusable content widget for the Projects tab/body.
class ProjectsTabContent extends ConsumerWidget {
  const ProjectsTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final projects = projectState.projects;
    final highlightProject =
        projects.isNotEmpty ? projects.first : _fallbackProject;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo-only header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Image.asset(
              'assets/icons/logo.png',
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback: Show app name if logo not found
                return const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.textDarkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title "Projects" with orange dot - increased size
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.projects,
                      style: AppTextStyles.extraLargeHeading(
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Increased spacing
                // Highlight card; tap opens project detail
                ProjectHighlightCard(
                  project: highlightProject,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ProjectDetailScreen(project: highlightProject),
                    ),
                  ),
                ),
                // TODO: Add more project cards / list below as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fallback project data in case provider has not loaded yet.
  ProjectModel get _fallbackProject => ProjectModel(
        id: 'fallback',
        name: 'Golden Cendrawasih Residence',
        description: 'Perumahan modern di Tamalate, Kota Makassar.',
        imageUrl: 'assets/images/hero/SSEH.png',
        isFeatured: true,
        status: 'On Going Project',
      );
}

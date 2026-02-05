import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/project_provider.dart';
import '../../widgets/home/project_card.dart';

/// "Our Projects" section
class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final projects = projectState.projects;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          Text(
            AppStrings.ourProjects,
            style: AppTextStyles.sectionHeading(),
          ),
          const SizedBox(height: 24),
          // Project cards
          if (projects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No projects available',
                  style: TextStyle(color: AppColors.darkGray),
                ),
              ),
            )
          else
            ...projects.map((project) {
              return ProjectCard(
                project: project,
                onSeeMoreTap: () {
                  // TODO: Navigate to project detail screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${project.name}...'),
                    ),
                  );
                },
              );
            }).toList(),
        ],
      ),
    );
  }
}

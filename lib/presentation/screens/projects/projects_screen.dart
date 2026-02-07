import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../providers/navigation_provider.dart';
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
class ProjectsTabContent extends ConsumerStatefulWidget {
  const ProjectsTabContent({super.key});

  @override
  ConsumerState<ProjectsTabContent> createState() => _ProjectsTabContentState();
}

class _ProjectsTabContentState extends ConsumerState<ProjectsTabContent> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _projectKeys = {};

  @override
  void initState() {
    super.initState();
    // Scroll to selected project after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedProject();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedProject() {
    final selectedId = ref.read(navigationProvider.notifier).selectedProjectId;
    if (selectedId != null && _projectKeys.containsKey(selectedId)) {
      final key = _projectKeys[selectedId]!;
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1, // Scroll to near top
        );
      }
      // Clear selection after scrolling
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          ref.read(navigationProvider.notifier).clearSelectedProject();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final projects = projectState.projects;
    final selectedId = ref.watch(navigationProvider.notifier).selectedProjectId;

    // Create keys for each project
    for (var project in projects) {
      _projectKeys.putIfAbsent(project.id, () => GlobalKey());
    }

    return SingleChildScrollView(
      controller: _scrollController,
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
                const SizedBox(height: 40),

                // Show all projects
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
                    final isSelected = project.id == selectedId;
                    return Container(
                      key: _projectKeys[project.id],
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: isSelected
                          ? BoxDecoration(
                              border: Border.all(
                                color: AppColors.orange,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: ProjectHighlightCard(
                        project: project,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProjectDetailScreen(project: project),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

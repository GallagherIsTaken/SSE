import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../providers/project_provider.dart';
import 'enhanced_project_edit_dialog.dart';

class ProjectsManagementScreen extends ConsumerStatefulWidget {
  const ProjectsManagementScreen({super.key});

  @override
  ConsumerState<ProjectsManagementScreen> createState() =>
      _ProjectsManagementScreenState();
}

class _ProjectsManagementScreenState
    extends ConsumerState<ProjectsManagementScreen> {
  final _repository = ProjectRepository();

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Projects Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
        onPressed: () => _showEditDialog(context),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Projects',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add, edit, or remove projects from your portfolio',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: projectsAsync.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: projectsAsync.projects.length,
                        itemBuilder: (context, index) {
                          final project = projectsAsync.projects[index];
                          final isMobile =
                              MediaQuery.of(context).size.width < 600;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isMobile
                                ? _buildMobileProjectCard(project)
                                : _buildDesktopProjectCard(project),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileProjectCard(ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and title row
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  image: project.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(project.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: project.imageUrl.isEmpty
                    ? Icon(Icons.image, color: Colors.grey[400], size: 24)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: project.status == 'On Going Project'
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            project.status,
                            style: TextStyle(
                              color: project.status == 'On Going Project'
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  project.isFeatured ? Icons.star : Icons.star_border,
                  color: project.isFeatured ? Colors.orange : Colors.grey,
                ),
                onPressed: () => _toggleFeatured(project),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, project),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, project),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProjectCard(ProjectModel project) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          image: project.imageUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(project.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: project.imageUrl.isEmpty
            ? Icon(Icons.image, color: Colors.grey[400], size: 32)
            : null,
      ),
      title: Text(
        project.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: project.status == 'On Going Project'
                ? Colors.orange.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            project.status,
            style: TextStyle(
              color: project.status == 'On Going Project'
                  ? Colors.orange[700]
                  : Colors.green[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              project.isFeatured ? Icons.star : Icons.star_border,
              color: project.isFeatured ? Colors.orange : Colors.grey,
            ),
            onPressed: () => _toggleFeatured(project),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditDialog(context, project),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, project),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFeatured(ProjectModel project) async {
    try {
      await _repository.saveProject(
        project.copyWith(isFeatured: !project.isFeatured),
      );
      ref.read(projectProvider.notifier).loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(project.isFeatured
                ? 'Removed from featured'
                : 'Added to featured'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating project: $e')),
        );
      }
    }
  }

  void _showEditDialog(BuildContext context, [ProjectModel? project]) {
    // Capture the screen's context (not the dialog's context)
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => EnhancedProjectEditDialog(
        project: project,
        onSave: (model) async {
          try {
            await _repository.saveProject(model);
            ref.read(projectProvider.notifier).loadData();

            // Close the dialog first
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }

            // Then show success message using the captured ScaffoldMessenger
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Project saved successfully')),
            );
          } catch (e) {
            // Close the dialog first
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }

            // Then show error message using the captured ScaffoldMessenger
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Error saving project: $e')),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProjectModel project) {
    // Capture the screen's context (not the dialog's context)
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await _repository.deleteProject(project.id);
                ref.read(projectProvider.notifier).loadData();

                // Close the dialog first
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }

                // Then show success message using the captured ScaffoldMessenger
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Project deleted successfully')),
                );
              } catch (e) {
                // Close the dialog first
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }

                // Then show error message using the captured ScaffoldMessenger
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Error deleting project: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

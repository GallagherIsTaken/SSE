import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../providers/project_provider.dart';
import '../widgets/admin_image_picker.dart';

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
                            child: ListTile(
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
                                    ? Icon(Icons.image,
                                        color: Colors.grey[400], size: 32)
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
                                      color:
                                          project.status == 'On Going Project'
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
                                      project.isFeatured
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: project.isFeatured
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await _repository.saveProject(
                                          project.copyWith(
                                              isFeatured: !project.isFeatured),
                                        );
                                        ref
                                            .read(projectProvider.notifier)
                                            .loadData();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(project.isFeatured
                                                  ? 'Removed from featured'
                                                  : 'Added to featured'),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error updating project: $e')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _showEditDialog(context, project),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteDialog(context, project),
                                  ),
                                ],
                              ),
                            ),
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

  void _showEditDialog(BuildContext context, [ProjectModel? project]) {
    showDialog(
      context: context,
      builder: (context) => _ProjectEditDialog(
        project: project,
        onSave: (model) async {
          try {
            await _repository.saveProject(model);
            ref.read(projectProvider.notifier).loadData();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project saved successfully')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving project: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await _repository.deleteProject(project.id);
                ref.read(projectProvider.notifier).loadData();
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Project deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting project: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectEditDialog extends StatefulWidget {
  final ProjectModel? project;
  final Function(ProjectModel) onSave;

  const _ProjectEditDialog({this.project, required this.onSave});

  @override
  State<_ProjectEditDialog> createState() => _ProjectEditDialogState();
}

class _ProjectEditDialogState extends State<_ProjectEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _statusController;
  String _imageUrl = '';
  bool _isFeatured = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descController =
        TextEditingController(text: widget.project?.description ?? '');
    _statusController = TextEditingController(
        text: widget.project?.status ?? 'On Going Project');
    _imageUrl = widget.project?.imageUrl ?? '';
    _isFeatured = widget.project?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminImagePicker(
                  initialImageUrl: _imageUrl,
                  onImageChanged: (url) => setState(() => _imageUrl = url),
                  label: 'Project Image',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _statusController.text,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(
                        value: 'On Going Project',
                        child: Text('On Going Project')),
                    DropdownMenuItem(
                        value: 'Completed', child: Text('Completed')),
                  ],
                  onChanged: (v) => setState(() => _statusController.text = v!),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Featured Project'),
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newProject = ProjectModel(
                id: widget.project?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                description: _descController.text,
                imageUrl: _imageUrl,
                status: _statusController.text,
                isFeatured: _isFeatured,
                features: widget.project?.features ?? [],
              );
              widget.onSave(newProject);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

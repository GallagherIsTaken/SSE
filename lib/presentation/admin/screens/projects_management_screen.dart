import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../providers/project_provider.dart'; // Fixed import path
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
      appBar: AppBar(
        title: const Text('Manage Projects'),
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add),
        onPressed: () => _showEditDialog(context),
      ),
      body: projectsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projectsAsync.projects.length,
              itemBuilder: (context, index) {
                final project = projectsAsync.projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                        image: project.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(project.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: project.imageUrl.isEmpty
                          ? const Icon(Icons.image, color: Colors.grey)
                          : null,
                    ),
                    title: Text(project.name),
                    subtitle: Text(
                      project.status,
                      style: TextStyle(
                        color: project.status == 'On Going Project'
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            project.isFeatured ? Icons.star : Icons.star_border,
                            color: project.isFeatured
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            // Toggle featured status
                            final updated = project.copyWith(
                                isFeatured: !project.isFeatured);
                            // TODO: Add save method to repository if not exists in mock
                            // For now assuming we have a way to save or rebuild provider
                            // _repository.saveProject(updated);
                            // ref.read(projectProvider.notifier).loadData();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showEditDialog(context, project: project),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, project),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDialog(BuildContext context, {ProjectModel? project}) {
    showDialog(
      context: context,
      builder: (context) => _ProjectEditDialog(
          project: project,
          onSave: (model) async {
            // TODO: Implement save logic calling _repository
            // await _repository.saveProject(model);
            // ref.read(projectProvider.notifier).loadData();
          }),
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
              // Call delete API
              // await _repository.deleteProject(project.id);
              // ref.read(projectProvider.notifier).loadData();
              Navigator.of(context).pop();
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

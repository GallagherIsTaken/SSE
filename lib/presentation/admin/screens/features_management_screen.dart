import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/feature_model.dart';
import '../../../../data/repositories/project_repository.dart';

class FeaturesManagementScreen extends StatefulWidget {
  const FeaturesManagementScreen({super.key});

  @override
  State<FeaturesManagementScreen> createState() =>
      _FeaturesManagementScreenState();
}

class _FeaturesManagementScreenState extends State<FeaturesManagementScreen> {
  final _repository = ProjectRepository();
  List<FeatureModel> _features = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatures();
  }

  Future<void> _loadFeatures() async {
    setState(() => _isLoading = true);
    try {
      final features = await _repository.getFeatures();
      setState(() {
        _features = List.from(features);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showEditDialog({FeatureModel? feature}) {
    showDialog(
      context: context,
      builder: (context) => _FeatureEditDialog(
        feature: feature,
        onSave: (newFeature) async {
          try {
            await _repository.saveFeature(newFeature);
            await _loadFeatures();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feature saved successfully')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving feature: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Features'),
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add),
        onPressed: () => _showEditDialog(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns for mobile, adapt for web later
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(feature.icon,
                            size: 40, color: AppColors.primaryDarkGreen),
                        const SizedBox(height: 8),
                        Text(
                          feature.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showEditDialog(feature: feature),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Show confirmation dialog
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Feature'),
                                    content: Text(
                                        'Are you sure you want to delete "${feature.name}"?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  try {
                                    await _repository.deleteFeature(feature.id);
                                    await _loadFeatures();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Feature deleted successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error deleting feature: $e')),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _FeatureEditDialog extends StatefulWidget {
  final FeatureModel? feature;
  final Function(FeatureModel) onSave;

  const _FeatureEditDialog({this.feature, required this.onSave});

  @override
  State<_FeatureEditDialog> createState() => _FeatureEditDialogState();
}

class _FeatureEditDialogState extends State<_FeatureEditDialog> {
  late TextEditingController _nameController;
  late IconData _selectedIcon;

  // Common icons for real estate
  final List<IconData> _iconOptions = [
    Icons.home,
    Icons.apartment,
    Icons.pool,
    Icons.wifi,
    Icons.security,
    Icons.local_parking,
    Icons.fitness_center,
    Icons.park,
    Icons.shopping_cart,
    Icons.school,
    Icons.local_hospital,
    Icons.restaurant,
    Icons.train,
    Icons.directions_bus,
    Icons.ac_unit,
    Icons.elevator,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.feature?.name ?? '');
    _selectedIcon = widget.feature?.icon ?? Icons.home;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.feature == null ? 'Add Feature' : 'Edit Feature'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Feature Name'),
            ),
            const SizedBox(height: 16),
            const Text('Select Icon:'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _iconOptions.length,
                itemBuilder: (context, index) {
                  final icon = _iconOptions[index];
                  final isSelected = _selectedIcon == icon;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryDarkGreen.withOpacity(0.1)
                            : null,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primaryDarkGreen, width: 2)
                            : Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? AppColors.primaryDarkGreen
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
            if (_nameController.text.isNotEmpty) {
              final newFeature = FeatureModel(
                id: widget.feature?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                icon: _selectedIcon,
              );
              widget.onSave(newFeature);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

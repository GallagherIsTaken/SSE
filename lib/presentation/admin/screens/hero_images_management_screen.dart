import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../../../data/models/hero_image_model.dart';
import '../widgets/admin_image_picker.dart';

class HeroImagesManagementScreen extends StatefulWidget {
  const HeroImagesManagementScreen({super.key});

  @override
  State<HeroImagesManagementScreen> createState() =>
      _HeroImagesManagementScreenState();
}

class _HeroImagesManagementScreenState
    extends State<HeroImagesManagementScreen> {
  final ProjectRepository _repository = ProjectRepository();
  List<HeroImageModel> _heroImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);
    try {
      final images = await _repository.getHeroImages();
      setState(() {
        _heroImages = List.from(images);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddImageDialog() {
    String newUrl = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Hero Image'),
        content: SizedBox(
          width: 500,
          child: AdminImagePicker(
            onImageChanged: (url) => newUrl = url,
            label: 'Hero Image URL',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () async {
              if (newUrl.isNotEmpty) {
                try {
                  await _repository.addHeroImage(newUrl);
                  await _loadImages();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Hero image added successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding hero image: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Hero Images Management'),
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
        label: const Text('Add Image'),
        onPressed: _showAddImageDialog,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Hero Images',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add, reorder, or remove hero carousel images',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ReorderableListView(
                        padding: EdgeInsets.zero,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final HeroImageModel item =
                                _heroImages.removeAt(oldIndex);
                            _heroImages.insert(newIndex, item);
                          });
                          // TODO: Save order to repository
                        },
                        children: [
                          for (int index = 0;
                              index < _heroImages.length;
                              index++)
                            Container(
                              key: ValueKey(_heroImages[index].id),
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
                                  width: 100,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _heroImages[index].imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Slide ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      await _repository.deleteHeroImage(
                                          _heroImages[index].id);
                                      await _loadImages();
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Hero image deleted successfully')),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error deleting image: $e')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/repositories/project_repository.dart';
import '../widgets/admin_image_picker.dart';

class HeroImagesManagementScreen extends StatefulWidget {
  const HeroImagesManagementScreen({super.key});

  @override
  State<HeroImagesManagementScreen> createState() =>
      _HeroImagesManagementScreenState();
}

class _HeroImagesManagementScreenState
    extends State<HeroImagesManagementScreen> {
  final _repository = ProjectRepository();
  List<String> _heroImages = [];
  bool _isLoading = true;

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

  void _showAddDialog() {
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
            onPressed: () {
              if (newUrl.isNotEmpty) {
                setState(() {
                  _heroImages.add(newUrl);
                });
                // TODO: Save to repository
                Navigator.of(context).pop();
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
      appBar: AppBar(
        title: const Text('Manage Hero Images'),
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              padding: const EdgeInsets.all(16),
              header: const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Drag to reorder images',
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
              children: [
                for (int index = 0; index < _heroImages.length; index++)
                  Card(
                    key: ValueKey(_heroImages[index]), // Key must be unique
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(_heroImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text('Slide ${index + 1}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _heroImages.removeAt(index);
                          });
                          // TODO: Save changes
                        },
                      ),
                    ),
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = _heroImages.removeAt(oldIndex);
                  _heroImages.insert(newIndex, item);
                });
                // TODO: Save order to repository
              },
            ),
    );
  }
}

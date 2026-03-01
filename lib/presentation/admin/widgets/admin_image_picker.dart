import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/firebase_storage_service.dart';

class AdminImagePicker extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String) onImageChanged;
  final String label;
  final String storageFolder;
  final String? storageSubfolder;

  const AdminImagePicker({
    super.key,
    this.initialImageUrl,
    required this.onImageChanged,
    this.label = 'Image',
    this.storageFolder = 'images',
    this.storageSubfolder,
  });

  @override
  State<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends State<AdminImagePicker> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  String? _currentImageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      // Pick image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      if (!mounted) return;

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Generate storage path
      final String path = _storageService.generateImagePath(
        folder: widget.storageFolder,
        subfolder: widget.storageSubfolder,
        extension: pickedFile.path.split('.').last,
      );

      // Upload image
      final File imageFile = File(pickedFile.path);
      final String downloadUrl = await _storageService.uploadImageWithProgress(
        imageFile,
        path,
        (progress) {
          if (mounted) {
            setState(() {
              _uploadProgress = progress;
            });
          }
        },
      );

      // Update state and notify parent
      if (!mounted) return;

      setState(() {
        _currentImageUrl = downloadUrl;
        _isUploading = false;
      });

      widget.onImageChanged(downloadUrl);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage() {
    // Delete from Firebase Storage if it's a Firebase URL
    if (_currentImageUrl != null &&
        _storageService.isFirebaseStorageUrl(_currentImageUrl!)) {
      _storageService.deleteImageByUrl(_currentImageUrl!);
    }

    setState(() {
      _currentImageUrl = null;
    });

    widget.onImageChanged('');
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: _buildImagePreview(),
            ),
            const SizedBox(width: 16),
            // Upload Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isUploading) ...[
                    const Text(
                      'Uploading...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: _uploadProgress),
                    const SizedBox(height: 8),
                    Text(
                      '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(Icons.upload, size: 20),
                        label: Text(
                          _currentImageUrl == null ? 'Upload' : 'Change',
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload from:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Gallery or Camera',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stored in Firebase',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_isUploading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _currentImageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Invalid URL',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  onPressed: _removeImage,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text('No Image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

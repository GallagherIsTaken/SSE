import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminImagePicker extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String) onImageChanged;
  final String label;

  const AdminImagePicker({
    super.key,
    this.initialImageUrl,
    required this.onImageChanged,
    this.label = 'Image URL',
  });

  @override
  State<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends State<AdminImagePicker> {
  late TextEditingController _controller;
  String? _previewUrl;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialImageUrl);
    _previewUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _previewUrl = _controller.text;
    });
    widget.onImageChanged(_controller.text);
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
              child: _previewUrl != null && _previewUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _previewUrl!,
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
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
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
                                icon: const Icon(Icons.close,
                                    size: 16, color: Colors.white),
                                onPressed: () {
                                  _controller.clear();
                                  _updatePreview();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No Image', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
            ),
            const SizedBox(width: 16),
            // URL Input
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'External Image URL',
                      hintText: 'https://i.ibb.co/.../image.jpg',
                      border: OutlineInputBorder(),
                      helperText: 'Paste direct link from ImgBB or Cloudinary',
                      prefixIcon: Icon(Icons.link),
                    ),
                    onChanged: (value) => _updatePreview(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How to get URL:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      // TODO: Launch ImgBB
                    },
                    child: const Text(
                      '1. Upload to ImgBB.com ->',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text('2. Copy "Direct Link" URL'),
                  const Text('3. Paste here'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

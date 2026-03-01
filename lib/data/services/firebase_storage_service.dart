import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service for managing Firebase Storage operations
/// Handles image uploads, deletions, and URL retrieval
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload an image file to Firebase Storage
  ///
  /// [imageFile] - The image file to upload
  /// [path] - The storage path (e.g., 'projects/project123/image.jpg')
  ///
  /// Returns the download URL of the uploaded image
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      // Create a reference to the file location
      final Reference ref = _storage.ref().child(path);

      // Upload the file
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  /// Upload an image with progress tracking
  ///
  /// [imageFile] - The image file to upload
  /// [path] - The storage path
  /// [onProgress] - Callback for upload progress (0.0 to 1.0)
  ///
  /// Returns the download URL of the uploaded image
  Future<String> uploadImageWithProgress(
    File imageFile,
    String path,
    Function(double)? onProgress,
  ) async {
    try {
      final Reference ref = _storage.ref().child(path);
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image with progress: $e');
      rethrow;
    }
  }

  /// Delete an image from Firebase Storage using its URL
  ///
  /// [imageUrl] - The full download URL of the image
  Future<void> deleteImageByUrl(String imageUrl) async {
    try {
      // Extract the storage path from the URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
      // Don't rethrow - deletion failures shouldn't block other operations
    }
  }

  /// Delete an image from Firebase Storage using its path
  ///
  /// [path] - The storage path (e.g., 'projects/project123/image.jpg')
  Future<void> deleteImageByPath(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print('Error deleting image by path: $e');
      // Don't rethrow - deletion failures shouldn't block other operations
    }
  }

  /// Generate a unique file path for an image
  ///
  /// [folder] - The folder name (e.g., 'projects', 'hero_images', 'contacts')
  /// [subfolder] - Optional subfolder (e.g., project ID)
  /// [extension] - File extension (default: 'jpg')
  ///
  /// Returns a unique path like 'projects/project123/1234567890.jpg'
  String generateImagePath({
    required String folder,
    String? subfolder,
    String extension = 'jpg',
  }) {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String filename = '$timestamp.$extension';

    if (subfolder != null && subfolder.isNotEmpty) {
      return '$folder/$subfolder/$filename';
    } else {
      return '$folder/$filename';
    }
  }

  /// Check if a URL is a Firebase Storage URL
  bool isFirebaseStorageUrl(String url) {
    return url.contains('firebasestorage.googleapis.com');
  }
}

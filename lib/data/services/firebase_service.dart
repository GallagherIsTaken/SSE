import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/feature_model.dart';

/// Firebase service for managing app data
/// Uses Firestore for data storage and external URLs for images
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String _projectsCollection = 'projects';
  static const String _featuresCollection = 'features';
  static const String _heroImagesCollection = 'hero_images';

  /// Get all projects from Firestore
  Future<List<ProjectModel>> getProjects() async {
    try {
      final snapshot = await _firestore
          .collection(_projectsCollection)
          .orderBy('isFeatured', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProjectModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  /// Get all features from Firestore
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final snapshot = await _firestore.collection(_featuresCollection).get();

      return snapshot.docs
          .map((doc) => FeatureModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching features: $e');
      return [];
    }
  }

  /// Get hero carousel image URLs from Firestore
  Future<List<String>> getHeroImages() async {
    try {
      final snapshot = await _firestore
          .collection(_heroImagesCollection)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['imageUrl'] as String? ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error fetching hero images: $e');
      return [];
    }
  }

  /// Stream of projects (real-time updates)
  Stream<List<ProjectModel>> projectsStream() {
    return _firestore
        .collection(_projectsCollection)
        .orderBy('isFeatured', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  /// Stream of features (real-time updates)
  Stream<List<FeatureModel>> featuresStream() {
    return _firestore
        .collection(_featuresCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeatureModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  /// Stream of hero images (real-time updates)
  Stream<List<String>> heroImagesStream() {
    return _firestore
        .collection(_heroImagesCollection)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()['imageUrl'] as String? ?? '')
            .where((url) => url.isNotEmpty)
            .toList());
  }

  // Admin methods (for admin panel)

  /// Add or update a project
  Future<void> saveProject(ProjectModel project) async {
    try {
      await _firestore
          .collection(_projectsCollection)
          .doc(project.id)
          .set(project.toJson());
    } catch (e) {
      print('Error saving project: $e');
      rethrow;
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(_projectsCollection).doc(projectId).delete();
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }

  /// Add or update a feature
  Future<void> saveFeature(FeatureModel feature) async {
    try {
      await _firestore
          .collection(_featuresCollection)
          .doc(feature.id)
          .set(feature.toJson());
    } catch (e) {
      print('Error saving feature: $e');
      rethrow;
    }
  }

  /// Delete a feature
  Future<void> deleteFeature(String featureId) async {
    try {
      await _firestore.collection(_featuresCollection).doc(featureId).delete();
    } catch (e) {
      print('Error deleting feature: $e');
      rethrow;
    }
  }

  // Note: Images are hosted externally (ImgBB, Cloudinary, etc.)
  // Upload images to your preferred service and use the public URLs
  // in the imageUrl fields when creating/updating projects and hero images

  /// Add hero image with external URL
  Future<void> addHeroImage(String imageUrl, int order) async {
    try {
      await _firestore.collection(_heroImagesCollection).add({
        'imageUrl': imageUrl,
        'order': order,
      });
    } catch (e) {
      print('Error adding hero image: $e');
      rethrow;
    }
  }

  /// Delete hero image
  Future<void> deleteHeroImage(String docId) async {
    try {
      await _firestore.collection(_heroImagesCollection).doc(docId).delete();
    } catch (e) {
      print('Error deleting hero image: $e');
      rethrow;
    }
  }
}

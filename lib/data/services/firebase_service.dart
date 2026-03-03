import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/feature_model.dart';
import '../models/hero_image_model.dart';
import '../models/contact_model.dart';

/// Firebase service for managing app data
/// Uses Firestore for data storage and Firebase Storage for images
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String _projectsCollection = 'projects';
  static const String _featuresCollection = 'features';
  static const String _heroImagesCollection = 'hero_images';
  static const String _contactsCollection = 'contacts';

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

  /// Get hero carousel images from Firestore
  Future<List<HeroImageModel>> getHeroImages() async {
    try {
      final snapshot = await _firestore
          .collection(_heroImagesCollection)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => HeroImageModel.fromJson(doc.data(), doc.id))
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

  /// Get all contacts from Firestore
  Future<List<ContactModel>> getContacts() async {
    try {
      final snapshot = await _firestore
          .collection(_contactsCollection)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => ContactModel.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  /// Stream of contacts (real-time updates)
  Stream<List<ContactModel>> contactsStream() {
    return _firestore
        .collection(_contactsCollection)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ContactModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
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

  // Images are hosted in Firebase Storage
  // The AdminImagePicker widget handles uploading images and returns
  // the Firebase Storage download URLs to use in imageUrl fields

  /// Add hero image with external URL (auto-calculates order)
  Future<void> addHeroImage(String imageUrl) async {
    try {
      // Get current max order
      final snapshot = await _firestore
          .collection(_heroImagesCollection)
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      int nextOrder = 0;
      if (snapshot.docs.isNotEmpty) {
        nextOrder = (snapshot.docs.first.data()['order'] as int? ?? -1) + 1;
      }

      await _firestore.collection(_heroImagesCollection).add({
        'imageUrl': imageUrl,
        'order': nextOrder,
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

  /// Add or update a contact
  Future<void> saveContact(ContactModel contact) async {
    try {
      await _firestore
          .collection(_contactsCollection)
          .doc(contact.id)
          .set(contact.toJson());
    } catch (e) {
      print('Error saving contact: $e');
      rethrow;
    }
  }

  /// Delete a contact
  Future<void> deleteContact(String contactId) async {
    try {
      await _firestore.collection(_contactsCollection).doc(contactId).delete();
    } catch (e) {
      print('Error deleting contact: $e');
      rethrow;
    }
  }

  // ── App Settings (office location, etc.) ─────────────────
  static const String _settingsCollection = 'settings';
  static const String _settingsDocId = 'app_settings';

  /// Get office location from settings
  Future<Map<String, double?>> getOfficeLocation() async {
    try {
      final doc = await _firestore
          .collection(_settingsCollection)
          .doc(_settingsDocId)
          .get();
      if (!doc.exists) return {'lat': null, 'lng': null};
      final data = doc.data()!;
      double? _safeDouble(dynamic v) {
        if (v == null) return null;
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v);
        return null;
      }

      return {
        'lat': _safeDouble(data['officeLatitude']),
        'lng': _safeDouble(data['officeLongitude']),
      };
    } catch (e) {
      print('Error fetching office location: $e');
      return {'lat': null, 'lng': null};
    }
  }

  /// Save office location to settings
  Future<void> saveOfficeLocation(double lat, double lng) async {
    await _firestore.collection(_settingsCollection).doc(_settingsDocId).set(
        {'officeLatitude': lat, 'officeLongitude': lng},
        SetOptions(merge: true));
  }
}

import '../models/project_model.dart';
import '../models/feature_model.dart';
import '../services/firebase_service.dart';
import 'package:flutter/material.dart';

/// Repository for managing project data
/// Uses Firebase with fallback to mock data
class ProjectRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Cache for offline support
  List<ProjectModel>? _cachedProjects;
  List<FeatureModel>? _cachedFeatures;
  List<String>? _cachedHeroImages;

  // Mock hero carousel images (fallback)
  static const List<String> _mockHeroImages = [
    'assets/images/hero/SSEH.png',
    'assets/images/hero/SSEH.png',
  ];

  /// Get hero carousel images
  Future<List<String>> getHeroImages() async {
    try {
      final images = await _firebaseService.getHeroImages();
      if (images.isNotEmpty) {
        _cachedHeroImages = images;
        return images;
      }
    } catch (e) {
      print('Error fetching hero images from Firebase: $e');
    }

    // Return cached data or fallback to mock data
    return _cachedHeroImages ?? _mockHeroImages;
  }

  /// Get all features for hero banner
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final features = await _firebaseService.getFeatures();
      if (features.isNotEmpty) {
        _cachedFeatures = features;
        return features;
      }
    } catch (e) {
      print('Error fetching features from Firebase: $e');
    }

    // Return cached data or fallback to mock data
    return _cachedFeatures ?? _getMockFeatures();
  }

  /// Get all projects
  Future<List<ProjectModel>> getProjects() async {
    try {
      final projects = await _firebaseService.getProjects();
      if (projects.isNotEmpty) {
        _cachedProjects = projects;
        return projects;
      }
    } catch (e) {
      print('Error fetching projects from Firebase: $e');
    }

    // Return cached data or fallback to mock data
    return _cachedProjects ?? _getMockProjects();
  }

  /// Stream of projects (real-time updates)
  Stream<List<ProjectModel>> projectsStream() {
    return _firebaseService.projectsStream();
  }

  /// Stream of features (real-time updates)
  Stream<List<FeatureModel>> featuresStream() {
    return _firebaseService.featuresStream();
  }

  /// Stream of hero images (real-time updates)
  Stream<List<String>> heroImagesStream() {
    return _firebaseService.heroImagesStream();
  }

  // Mock data fallbacks
  List<FeatureModel> _getMockFeatures() {
    return [
      FeatureModel(
        id: '1',
        name: 'Smart Living Concept',
        icon: Icons.home_outlined,
      ),
      FeatureModel(
        id: '2',
        name: 'Play Ground',
        icon: Icons.child_care,
      ),
      FeatureModel(
        id: '3',
        name: 'Internet Access',
        icon: Icons.wifi,
      ),
      FeatureModel(
        id: '4',
        name: 'Prime Location',
        icon: Icons.location_on,
      ),
      FeatureModel(
        id: '5',
        name: '24/7 Security',
        icon: Icons.security,
      ),
      FeatureModel(
        id: '6',
        name: 'One Gate System',
        icon: Icons.door_front_door,
      ),
      FeatureModel(
        id: '7',
        name: 'Free Design',
        icon: Icons.design_services,
      ),
      FeatureModel(
        id: '8',
        name: 'Free BPHTB',
        icon: Icons.receipt,
      ),
    ];
  }

  List<ProjectModel> _getMockProjects() {
    return [
      ProjectModel(
        id: '1',
        name: 'Golden Cendrawasih Residence',
        description:
            'Golden Cendrawasih Residence Terletak di jalan cendrawasih no 7 merupakan lokasi strategis lorem ipsum dolor sit amet. Kupas tuntas di sini. ipsum lorem.',
        imageUrl: 'assets/images/projects/cendrawasih.jpg',
        isFeatured: true,
        status: 'On Going Project',
      ),
      ProjectModel(
        id: '2',
        name: 'Golden Andi Tonro Residence',
        description:
            'Golden Andi Tonro Residence Terletak di lokasi strategis dengan akses mudah ke berbagai fasilitas. Lorem ipsum dolor sit amet consectetur adipiscing elit.',
        imageUrl: 'assets/images/projects/andi_tonro.jpg',
        isFeatured: true,
        status: 'On Going Project',
      ),
      ProjectModel(
        id: '3',
        name: 'Golden Bajeng Residence',
        description:
            'Golden Bajeng Residence menawarkan konsep hunian modern dengan fasilitas lengkap. Dapatkan rumah impian Anda di lokasi terbaik. Lorem ipsum dolor sit amet.',
        imageUrl: 'assets/images/projects/bajeng.jpg',
        isFeatured: true,
        status: 'On Going Project',
      ),
    ];
  }
}

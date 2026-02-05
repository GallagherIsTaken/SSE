import '../models/project_model.dart';
import '../models/feature_model.dart';
import 'package:flutter/material.dart';

/// Repository for managing project data
/// Currently uses mock data - ready for backend integration
class ProjectRepository {
  // Mock hero carousel images
  // TODO: Replace with your actual image paths
  // Place your hero images in: assets/images/hero/hero_1.jpg, hero_2.jpg, etc.
  static const List<String> heroImages = [
    'assets/images/hero/SSEH.png', // TODO: Add your hero image here
    'assets/images/hero/SSEH.png', // TODO: Add your hero image here
  ];

  /// Get hero carousel images
  List<String> getHeroImages() {
    return heroImages;
  }

  /// Get all features for hero banner
  List<FeatureModel> getFeatures() {
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

  /// Get all projects
  List<ProjectModel> getProjects() {
    return [
      ProjectModel(
        id: '1',
        name: 'Golden Cendrawasih Residence',
        description:
            'Golden Cendrawasih Residence Terletak di jalan cendrawasih no 7 merupakan lokasi strategis lorem ipsum dolor sit amet. Kupas tuntas di sini. ipsum lorem.',
        imageUrl: 'assets/images/projects/cendrawasih.jpg', // TODO: Add your project image here
        isFeatured: true,
        status: 'On Going Project',
      ),
      ProjectModel(
        id: '2',
        name: 'Golden Andi Tonro Residence',
        description:
            'Golden Andi Tonro Residence Terletak di lokasi strategis dengan akses mudah ke berbagai fasilitas. Lorem ipsum dolor sit amet consectetur adipiscing elit.',
        imageUrl: 'assets/images/projects/andi_tonro.jpg', // TODO: Add your project image here
        isFeatured: true,
        status: 'On Going Project',
      ),
      ProjectModel(
        id: '3',
        name: 'Golden Bajeng Residence',
        description:
            'Golden Bajeng Residence menawarkan konsep hunian modern dengan fasilitas lengkap. Dapatkan rumah impian Anda di lokasi terbaik. Lorem ipsum dolor sit amet.',
        imageUrl: 'assets/images/projects/bajeng.jpg', // TODO: Add your project image here
        isFeatured: true,
        status: 'On Going Project',
      ),
    ];
  }
}

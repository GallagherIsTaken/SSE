import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/project_model.dart';
import '../data/models/feature_model.dart';

/// Script to migrate mock data to Firebase
/// Run this once after setting up Firebase to populate initial data
class DataMigrationScript {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Run the complete migration
  Future<void> migrate() async {
    print('🚀 Starting data migration to Firebase...');

    try {
      await _migrateProjects();
      await _migrateFeatures();
      await _migrateHeroImages();

      print('✅ Migration completed successfully!');
    } catch (e) {
      print('❌ Migration failed: $e');
      rethrow;
    }
  }

  /// Migrate projects to Firestore
  Future<void> _migrateProjects() async {
    print('📦 Migrating projects...');

    final projects = [
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

    final batch = _firestore.batch();

    for (final project in projects) {
      final docRef = _firestore.collection('projects').doc(project.id);
      batch.set(docRef, project.toJson());
    }

    await batch.commit();
    print('✅ Migrated ${projects.length} projects');
    print(
        '⚠️  Note: Update imageUrl fields with external URLs (ImgBB, Cloudinary)');
  }

  /// Migrate features to Firestore
  Future<void> _migrateFeatures() async {
    print('⭐ Migrating features...');

    final features = [
      FeatureModel(
          id: '1', name: 'Smart Living Concept', icon: Icons.home_outlined),
      FeatureModel(id: '2', name: 'Play Ground', icon: Icons.child_care),
      FeatureModel(id: '3', name: 'Internet Access', icon: Icons.wifi),
      FeatureModel(id: '4', name: 'Prime Location', icon: Icons.location_on),
      FeatureModel(id: '5', name: '24/7 Security', icon: Icons.security),
      FeatureModel(
          id: '6', name: 'One Gate System', icon: Icons.door_front_door),
      FeatureModel(id: '7', name: 'Free Design', icon: Icons.design_services),
      FeatureModel(id: '8', name: 'Free BPHTB', icon: Icons.receipt),
    ];

    final batch = _firestore.batch();

    for (final feature in features) {
      final docRef = _firestore.collection('features').doc(feature.id);
      batch.set(docRef, feature.toJson());
    }

    await batch.commit();
    print('✅ Migrated ${features.length} features');
  }

  /// Migrate hero images to Firestore
  Future<void> _migrateHeroImages() async {
    print('🖼️  Migrating hero images...');

    // Note: Replace these with external URLs (ImgBB, Cloudinary)
    final heroImages = [
      {'imageUrl': 'assets/images/hero/SSEH.png', 'order': 0},
      {'imageUrl': 'assets/images/hero/SSEH.png', 'order': 1},
    ];

    final batch = _firestore.batch();

    for (var i = 0; i < heroImages.length; i++) {
      final docRef = _firestore.collection('hero_images').doc('hero_$i');
      batch.set(docRef, heroImages[i]);
    }

    await batch.commit();
    print('✅ Migrated ${heroImages.length} hero images');
    print(
        '⚠️  Note: Update imageUrl fields with external URLs (ImgBB, Cloudinary)');
  }
}

/// Widget to run migration from the app
class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool _isLoading = false;
  String _status = 'Ready to migrate data to Firebase';

  Future<void> _runMigration() async {
    setState(() {
      _isLoading = true;
      _status = 'Migrating data...';
    });

    try {
      final migration = DataMigrationScript();
      await migration.migrate();

      setState(() {
        _isLoading = false;
        _status = '✅ Migration completed successfully!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Migration failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Migration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 64, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                _status,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _runMigration,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Text('Start Migration'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

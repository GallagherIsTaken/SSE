import 'package:flutter/widgets.dart';

/// Feature model for hero banner features
class FeatureModel {
  final String id;
  final String name;
  final IconData icon; // Using Material Icons

  FeatureModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}

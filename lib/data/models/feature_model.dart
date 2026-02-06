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

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint, // Store icon code point
    };
  }

  /// Create from Firebase JSON
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: IconData(
        json['iconCode'] as int? ?? 0xe88a, // Default to home icon
        fontFamily: 'MaterialIcons',
      ),
    );
  }
}

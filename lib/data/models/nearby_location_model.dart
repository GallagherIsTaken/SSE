/// Model representing a nearby location with distance information
class NearbyLocationModel {
  final String id;
  final String name; // e.g., "Trans Studio Mall", "RS Hermina"
  final String
      category; // "Pusat Perbelanjaan", "Pendidikan", "Kesehatan", "Transportasi"
  final double distance; // Distance value
  final String distanceUnit; // "KM" or "MENIT"

  NearbyLocationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.distance,
    this.distanceUnit = 'KM',
  });

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'distance': distance,
      'distanceUnit': distanceUnit,
    };
  }

  /// Create from Firebase JSON
  factory NearbyLocationModel.fromJson(Map<String, dynamic> json) {
    return NearbyLocationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      distanceUnit: json['distanceUnit'] as String? ?? 'KM',
    );
  }

  NearbyLocationModel copyWith({
    String? id,
    String? name,
    String? category,
    double? distance,
    String? distanceUnit,
  }) {
    return NearbyLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      distance: distance ?? this.distance,
      distanceUnit: distanceUnit ?? this.distanceUnit,
    );
  }
}

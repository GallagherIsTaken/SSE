/// Model representing a nearby location with distance information
class NearbyLocationModel {
  final String id;
  final String name; // e.g., "Trans Studio Mall", "RS Hermina"
  final String
      category; // "Pusat Perbelanjaan", "Pendidikan", "Kesehatan", "Transportasi"
  final double distance; // Distance value
  final String distanceUnit; // "KM" or "MENIT"
  final double? latitude; // Optional latitude for map markers
  final double? longitude; // Optional longitude for map markers

  NearbyLocationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.distance,
    this.distanceUnit = 'KM',
    this.latitude,
    this.longitude,
  });

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'distance': distance,
      'distanceUnit': distanceUnit,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Create from Firebase JSON
  factory NearbyLocationModel.fromJson(Map<String, dynamic> json) {
    return NearbyLocationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      distance: _safeDouble(json['distance']),
      distanceUnit: json['distanceUnit'] as String? ?? 'KM',
      latitude: json['latitude'] != null ? _safeDouble(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? _safeDouble(json['longitude']) : null,
    );
  }

  static double _safeDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  NearbyLocationModel copyWith({
    String? id,
    String? name,
    String? category,
    double? distance,
    String? distanceUnit,
    double? latitude,
    double? longitude,
  }) {
    return NearbyLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      distance: distance ?? this.distance,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

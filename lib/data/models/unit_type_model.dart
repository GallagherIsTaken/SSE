/// Model representing a unit type/variant for a property project
class UnitTypeModel {
  final String id;
  final String name; // e.g., "Type 138", "Type 105"
  final double price; // in Rupiah
  final double landArea; // Luas Tanah in m²
  final double buildingArea; // Luas Bangunan in m²
  final int bedrooms; // Kamar Tidur
  final int bathrooms; // Kamar Mandi
  final int floors; // Jumlah Lantai

  UnitTypeModel({
    required this.id,
    required this.name,
    required this.price,
    required this.landArea,
    required this.buildingArea,
    required this.bedrooms,
    required this.bathrooms,
    this.floors = 1,
  });

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'landArea': landArea,
      'buildingArea': buildingArea,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floors': floors,
    };
  }

  /// Create from Firebase JSON
  factory UnitTypeModel.fromJson(Map<String, dynamic> json) {
    // Helper: safely parse a value that may be num, String, or null
    double safeDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    int safeInt(dynamic v, {int fallback = 0}) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    return UnitTypeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: safeDouble(json['price']),
      landArea: safeDouble(json['landArea']),
      buildingArea: safeDouble(json['buildingArea']),
      bedrooms: safeInt(json['bedrooms']),
      bathrooms: safeInt(json['bathrooms']),
      floors: safeInt(json['floors'], fallback: 1),
    );
  }

  UnitTypeModel copyWith({
    String? id,
    String? name,
    double? price,
    double? landArea,
    double? buildingArea,
    int? bedrooms,
    int? bathrooms,
    int? floors,
  }) {
    return UnitTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      landArea: landArea ?? this.landArea,
      buildingArea: buildingArea ?? this.buildingArea,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floors: floors ?? this.floors,
    );
  }
}

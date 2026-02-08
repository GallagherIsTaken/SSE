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
    return UnitTypeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      landArea: (json['landArea'] as num?)?.toDouble() ?? 0.0,
      buildingArea: (json['buildingArea'] as num?)?.toDouble() ?? 0.0,
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      floors: json['floors'] as int? ?? 1,
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

import 'unit_type_model.dart';
import 'nearby_location_model.dart';

/// Project model representing a real estate project
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // Main project image
  final List<String> imageGallery; // Additional project images for carousel
  final bool isFeatured;
  final String status; // e.g., "On Going Project"
  final List<String> features;

  // Price & Property Details
  final double? priceMin; // Minimum price in Juta (millions)
  final double? priceMax; // Maximum price in M (billions)
  final int? bedrooms; // Number of bedrooms (KT)
  final double? landArea; // Land area (LT) in m²
  final double? buildingArea; // Building area (LB) in m²
  final String? certificateType; // HGB, SHM, etc.
  final String? developerName;

  // Location Information
  final String? fullAddress;
  final String? district; // Kecamatan
  final String? city;
  final String? province;
  final double? latitude;
  final double? longitude;

  // Advertisement Image
  final String? adImageUrl;

  // Profile Image
  final String? profileImageUrl;

  // Projects Page Fields
  final String? subtitle; // e.g., "Rumah Tahap 1"
  final int? stockRemaining; // e.g., 4 for "Sisa 4 unit"
  final double? installmentStarting; // e.g., 3.29 for "Rp3,29 Juta/bln"
  final DateTime? lastUpdated; // For "Diperbarui X lalu"
  final String? brochureUrl; // External link for brochure button

  // Nearby Locations
  final List<NearbyLocationModel> nearbyLocations;

  // Unit Types
  final List<UnitTypeModel> unitTypes;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.imageGallery = const [],
    this.isFeatured = false,
    this.status = 'On Going Project',
    this.features = const [],
    this.priceMin,
    this.priceMax,
    this.bedrooms,
    this.landArea,
    this.buildingArea,
    this.certificateType,
    this.developerName,
    this.fullAddress,
    this.district,
    this.city,
    this.province,
    this.latitude,
    this.longitude,
    this.adImageUrl,
    this.profileImageUrl,
    this.subtitle,
    this.stockRemaining,
    this.installmentStarting,
    this.lastUpdated,
    this.brochureUrl,
    this.nearbyLocations = const [],
    this.unitTypes = const [],
  });

  /// Create a copy with updated fields
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? imageGallery,
    bool? isFeatured,
    String? status,
    List<String>? features,
    double? priceMin,
    double? priceMax,
    int? bedrooms,
    double? landArea,
    double? buildingArea,
    String? certificateType,
    String? developerName,
    String? fullAddress,
    String? district,
    String? city,
    String? province,
    double? latitude,
    double? longitude,
    String? adImageUrl,
    String? profileImageUrl,
    String? subtitle,
    int? stockRemaining,
    double? installmentStarting,
    DateTime? lastUpdated,
    String? brochureUrl,
    List<NearbyLocationModel>? nearbyLocations,
    List<UnitTypeModel>? unitTypes,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageGallery: imageGallery ?? this.imageGallery,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      features: features ?? this.features,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      bedrooms: bedrooms ?? this.bedrooms,
      landArea: landArea ?? this.landArea,
      buildingArea: buildingArea ?? this.buildingArea,
      certificateType: certificateType ?? this.certificateType,
      developerName: developerName ?? this.developerName,
      fullAddress: fullAddress ?? this.fullAddress,
      district: district ?? this.district,
      city: city ?? this.city,
      province: province ?? this.province,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      adImageUrl: adImageUrl ?? this.adImageUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      subtitle: subtitle ?? this.subtitle,
      stockRemaining: stockRemaining ?? this.stockRemaining,
      installmentStarting: installmentStarting ?? this.installmentStarting,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      brochureUrl: brochureUrl ?? this.brochureUrl,
      nearbyLocations: nearbyLocations ?? this.nearbyLocations,
      unitTypes: unitTypes ?? this.unitTypes,
    );
  }

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'imageGallery': imageGallery,
      'isFeatured': isFeatured,
      'status': status,
      'features': features,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'bedrooms': bedrooms,
      'landArea': landArea,
      'buildingArea': buildingArea,
      'certificateType': certificateType,
      'developerName': developerName,
      'fullAddress': fullAddress,
      'district': district,
      'city': city,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'adImageUrl': adImageUrl,
      'profileImageUrl': profileImageUrl,
      'subtitle': subtitle,
      'stockRemaining': stockRemaining,
      'installmentStarting': installmentStarting,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'brochureUrl': brochureUrl,
      'nearbyLocations': nearbyLocations.map((e) => e.toJson()).toList(),
      'unitTypes': unitTypes.map((e) => e.toJson()).toList(),
    };
  }

  /// Create from Firebase JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      imageGallery: (json['imageGallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isFeatured: json['isFeatured'] as bool? ?? false,
      status: json['status'] as String? ?? 'On Going Project',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      bedrooms: json['bedrooms'] as int?,
      landArea: (json['landArea'] as num?)?.toDouble(),
      buildingArea: (json['buildingArea'] as num?)?.toDouble(),
      certificateType: json['certificateType'] as String?,
      developerName: json['developerName'] as String?,
      fullAddress: json['fullAddress'] as String?,
      district: json['district'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      adImageUrl: json['adImageUrl'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      subtitle: json['subtitle'] as String?,
      stockRemaining: json['stockRemaining'] as int?,
      installmentStarting: (json['installmentStarting'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      brochureUrl: json['brochureUrl'] as String?,
      nearbyLocations: json['nearbyLocations'] != null
          ? (json['nearbyLocations'] as List<dynamic>)
              .map((e) =>
                  NearbyLocationModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      unitTypes: json['unitTypes'] != null
          ? (json['unitTypes'] as List<dynamic>)
              .map((e) => UnitTypeModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

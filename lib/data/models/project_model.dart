/// Project model representing a real estate project
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // Placeholder path - replace with your image path
  final bool isFeatured;
  final String status; // e.g., "On Going Project"
  final List<String> features;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isFeatured = false,
    this.status = 'On Going Project',
    this.features = const [],
  });

  /// Create a copy with updated fields
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isFeatured,
    String? status,
    List<String>? features,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      features: features ?? this.features,
    );
  }

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'status': status,
      'features': features,
    };
  }

  /// Create from Firebase JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      status: json['status'] as String? ?? 'On Going Project',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

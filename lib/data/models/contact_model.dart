/// Contact model for marketing contacts
class ContactModel {
  final String id;
  final String name;
  final String description;
  final String profilePictureUrl;
  final String whatsappLink;
  final int order;

  ContactModel({
    required this.id,
    required this.name,
    required this.description,
    required this.profilePictureUrl,
    required this.whatsappLink,
    required this.order,
  });

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profilePictureUrl': profilePictureUrl,
      'whatsappLink': whatsappLink,
      'order': order,
    };
  }

  /// Create from Firebase JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
      whatsappLink: json['whatsappLink'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  /// Get formatted WhatsApp URL
  String get whatsappUrl {
    // If already a full URL, return as is
    if (whatsappLink.startsWith('http')) {
      return whatsappLink;
    }

    // Otherwise, construct WhatsApp URL from phone number
    // Remove any non-digit characters
    final phoneNumber = whatsappLink.replaceAll(RegExp(r'[^0-9]'), '');
    return 'https://wa.me/$phoneNumber';
  }

  /// Copy with method for easy updates
  ContactModel copyWith({
    String? id,
    String? name,
    String? description,
    String? profilePictureUrl,
    String? whatsappLink,
    int? order,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      whatsappLink: whatsappLink ?? this.whatsappLink,
      order: order ?? this.order,
    );
  }
}

class HeroImageModel {
  final String id;
  final String imageUrl;
  final int order;

  HeroImageModel({
    required this.id,
    required this.imageUrl,
    required this.order,
  });

  factory HeroImageModel.fromJson(Map<String, dynamic> json, String docId) {
    return HeroImageModel(
      id: docId,
      imageUrl: json['imageUrl'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'order': order,
    };
  }
}

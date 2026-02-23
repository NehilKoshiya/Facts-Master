class FactModel {
  final int categoryId;
  final String categoryName;
  final String categoryImage;
  final List<String> facts;

  FactModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.facts,
  });

  factory FactModel.fromJson(Map<String, dynamic> json) {
    return FactModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
      facts: List<String>.from(json['facts']),
    );
  }
}

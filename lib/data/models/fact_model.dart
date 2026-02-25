class FactModel {
  final List<Datum> data;

  FactModel({required this.data});

  factory FactModel.fromJson(Map<String, dynamic> json) => FactModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String categoryTitleName;
  final List<CategoryList> categoryList;

  Datum({required this.categoryTitleName, required this.categoryList});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categoryTitleName: json["category_title_name"]?.toString() ?? "No Title",
    categoryList: json["category_list"] == null
        ? []
        : List<CategoryList>.from(
            json["category_list"].map((x) => CategoryList.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "category_title_name": categoryTitleName,
    "category_list": List<dynamic>.from(categoryList.map((x) => x.toJson())),
  };
}

class CategoryList {
  final int categoryId;
  final String categoryName;
  final String  categoryImage;
  final List<String> facts;

  CategoryList({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.facts,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    categoryId: json["category_id"] ?? 0,
    categoryName: json["category_name"]?.toString() ?? "Unknown",
    categoryImage: json["category_image"]?.toString() ?? "",
    facts: json["facts"] == null
        ? []
        : List<String>.from(json["facts"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "category_image": categoryImage,
    "facts": List<dynamic>.from(facts.map((x) => x)),
  };
}

import 'package:flutter/material.dart';

class AppThemeModel {
  final String image;
  final Color textColor;

  AppThemeModel({
    required this.image,
    required this.textColor,
  });

  /// for saving
  Map<String, dynamic> toJson() => {
    'image': image,
    'textColor': textColor.value,
  };

  /// for restoring
  factory AppThemeModel.fromJson(Map<String, dynamic> json) {
    return AppThemeModel(
      image: json['image'],
      textColor: Color(json['textColor']),
    );
  }
}

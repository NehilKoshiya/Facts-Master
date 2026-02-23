import 'package:flutter/material.dart';

class AppConfig {
  static const String apiBaseUrl = "https://api.example.com"; // change me

  static Future<void> init() async {
    // Load remote config, environment flags, etc.
    // For now, nothing to load.
    await Future.value(null);
  }
}

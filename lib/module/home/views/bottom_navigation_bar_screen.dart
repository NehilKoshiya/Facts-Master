import 'package:daily_facts/module/home/controllers/fact_controller.dart';
import 'package:daily_facts/module/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<FactController>()) {
      Get.put(FactController(), permanent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FactsReelsScreen();
  }
}

import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.bgColor,

        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Color(0xFF0D001C), Color(0xFF120021), Color(0xFF19002E)],
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  Assets.imagesAppLogo,
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              AppText(
                "Fact Master - Brain Bites",
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.white,
              ),

              const SizedBox(height: 6),

              AppText("Daily Facts", fontSize: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:daily_facts/module/home/controllers/fact_controller.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_text.dart';

class ThemesScreen extends StatelessWidget {
  ThemesScreen({super.key});

  final FactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Themes', context: context),

      // AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.close),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: const AppText('Themes'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: controller.themeImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (_, index) {
            final theme = controller.themeImages[index];

            return Obx(() {
              final isSelected =
                  controller.currentTheme.value?.image == theme.image;

              return GestureDetector(
                onTap: () => controller.selectTheme(theme),
                child: Stack(
                  children: [
                    theme.image.isEmpty
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E6DB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: AppText(
                                "default",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(theme.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                    /// SELECTED CHECK
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

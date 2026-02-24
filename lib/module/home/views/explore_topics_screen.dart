import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fact_controller.dart';
import 'category_facts_screen.dart';

class ExploreTopicsScreen extends StatelessWidget {
  ExploreTopicsScreen({super.key});

  final FactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        titleWidget: Obx(() {
          if (controller.isSearching.value) {
            return TextField(
              autofocus: true,
              onChanged: controller.searchCategory,
              decoration: const InputDecoration(
                hintText: 'Search categories',
                border: InputBorder.none,
              ),
            );
          }
          return const AppText(
            'Explore topics',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          );
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isSearching.value ? Icons.close : Icons.search,
              ),
              onPressed: controller.toggleSearch,
            );
          }),
        ],
        title: '',
        context: context,
      ),

      // AppBar(
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back),
      //   onPressed: () => Get.back(),
      // ),
      // title: Obx(() {
      //   if (controller.isSearching.value) {
      //     return TextField(
      //       autofocus: true,
      //       onChanged: controller.searchCategory,
      //       decoration: const InputDecoration(
      //         hintText: 'Search categories',
      //         border: InputBorder.none,
      //       ),
      //     );
      //   }
      //   return const AppText('Explore topics');
      // }),
      // actions: [
      //   Obx(() {
      //     return IconButton(
      //       icon: Icon(
      //         controller.isSearching.value ? Icons.close : Icons.search,
      //       ),
      //       onPressed: controller.toggleSearch,
      //     );
      //   }),
      // ],
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Obx(() {
          return GridView.builder(
            itemCount: controller.filteredCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, index) {
              final category = controller.filteredCategories[index];

              return InkWell(
                onTap: () {
                  controller.openCategory(category);
                  Get.to(() => CategoryFactsScreen());
                  controller.adCount();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/${category.categoryImage}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                        // color: Colors.grey.shade800,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 4,
                          top: 4,
                        ),
                        child: AppText(
                          category.categoryName,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

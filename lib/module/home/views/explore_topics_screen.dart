import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/data/models/fact_model.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/custom_text_filed.dart';

import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/fact_controller.dart';
import 'category_facts_screen.dart';

class ExploreTopicsScreen extends StatelessWidget {
  ExploreTopicsScreen({super.key});

  final FactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context),

      //  customAppBar(
      //   titleWidget: Container(
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       color: AppColors.itemBgColor,
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //     child: AppText(
      //       'Hey Fact Master - Brain Bites..!',
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   // titleWidget: Obx(() {
      //   //   if (controller.isSearching.value) {
      //   //     return CustomTextField(
      //   //       onChanged: controller.searchCategory,
      //   //       hintText: 'Search categories',
      //   //     );

      //   //     // TextField(
      //   //     //   autofocus: true,
      //   //     //   onChanged: controller.searchCategory,
      //   //     //   decoration: const InputDecoration(
      //   //     //     hintText: 'Search categories',
      //   //     //     border: InputBorder.none,
      //   //     //   ),
      //   //     // );
      //   //   }
      //   //   return const AppText(
      //   //     'Explore topics',
      //   //     fontSize: 18,
      //   //     fontWeight: FontWeight.w700,
      //   //     color: Colors.white,
      //   //   );
      //   // }),
      //   // actions: [
      //   //   Obx(() {
      //   //     return IconButton(
      //   //       icon: Icon(
      //   //         controller.isSearching.value ? Icons.close : Icons.search,
      //   //         color: Colors.white,
      //   //       ),
      //   //       onPressed: controller.toggleSearch,
      //   //     );
      //   //   }),
      //   // ],
      //   title: '',
      //   context: context,
      // ),

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
        padding: const EdgeInsets.only(right: 12, left: 12, top: 15),
        child: Obx(() {
          return ListView.separated(
            // controller: scrollController,
            itemBuilder: (context, index) {
              Datum? categoryData = controller.factData.value?.data[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.itemBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CustomVerticalDivider(),
                          Gap(10),
                          AppText(
                            categoryData?.categoryTitleName ?? '',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryData?.categoryList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, catIndex) {
                            final category =
                                categoryData?.categoryList[catIndex];

                            return InkWell(
                              onTap: () {
                                controller.openCategory(
                                  category ??
                                      CategoryList(
                                        categoryId: 0,
                                        categoryName: '',
                                        categoryImage: '',
                                        facts: [],
                                      ),
                                );
                                Get.to(() => CategoryFactsScreen());
                                controller.adCount();
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.categoryBgColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color.fromARGB(
                                            255,
                                            199,
                                            230,
                                            255,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Image.asset(
                                            fit: BoxFit.contain,
                                            'assets/images/${category?.categoryImage}',
                                          ),
                                        ),
                                      ),

                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(10),
                                      //   child: Image.asset(
                                      //     "assets/images/${category?.categoryImage}",
                                      //     height: 60,
                                      //     width: 60,
                                      //     fit: BoxFit.cover,
                                      //     errorBuilder:
                                      //         (context, error, stackTrace) =>
                                      //             const Icon(
                                      //               Icons.category,
                                      //               size: 40,
                                      //             ),
                                      //   ),
                                      // ),
                                      const SizedBox(height: 10),
                                      AppText(
                                        category?.categoryName ?? '',
                                        fontSize: 12,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Gap(20),
            itemCount: controller.factData.value?.data.length ?? 0,
          );

          //  GridView.builder(
          //   itemCount: controller.filteredCategories.length,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 16,
          //     crossAxisSpacing: 16,
          //     childAspectRatio: 1.1,
          //   ),
          //   itemBuilder: (_, index) {
          //     final category = controller.filteredCategories[index];

          //     return InkWell(
          //       onTap: () {
          //         controller.openCategory(category);
          // Get.to(() => CategoryFactsScreen());
          // controller.adCount();
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.grey.shade700,
          //           borderRadius: BorderRadius.circular(12),
          //           image: DecorationImage(
          //             image: AssetImage(
          //               "assets/images/${category.categoryImage}",
          //             ),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         child: Align(
          //           alignment: Alignment.bottomLeft,
          //           child: Container(
          //             width: double.infinity,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.only(
          //                 bottomLeft: Radius.circular(12),
          //                 bottomRight: Radius.circular(12),
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black45,
          //                   spreadRadius: 1,
          //                   blurRadius: 5,
          //                   offset: Offset(0, 0),
          //                 ),
          //               ],
          //               // color: Colors.grey.shade800,
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.only(
          //                 left: 8,
          //                 right: 8,
          //                 bottom: 4,
          //                 top: 4,
          //               ),
          //               child: AppText(
          //                 category.categoryName,
          //                 color: Colors.white,
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w800,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // );
        }),
      ),
    );
  }
}

import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/custom_button.dart';
import 'package:daily_facts/widgets/custom_text_filed.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import '../../../core/constants/constants.dart';
import '../../../generated/assets.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/app_text.dart';
import '../controllers/fact_controller.dart';

class CategoryFactsScreen extends StatelessWidget {
  CategoryFactsScreen({super.key});

  final FactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: controller.selectedCategoryName.value,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            /// SEARCH BAR
            CustomTextField(
              onChanged: controller.searchCategoryFacts,
              hintText: 'Search',
              prefixImage: Assets.imagesSearch,
              prefixColor: Colors.white,
            ),

            Gap(20),

            /// FACT LIST
            Expanded(
              child: Obx(() {
                if (controller.filteredCategoryFacts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No facts found',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredCategoryFacts.length,
                  itemBuilder: (_, index) {
                    final fact = controller.filteredCategoryFacts[index];
                    List data =
                        StorageService().read(Constants.likedMessages) ?? [];
                    RxBool isLiked = data.contains(fact).obs;
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.itemBgColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondItemBgColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: AppText(
                                    fact,
                                    textAlign: TextAlign.center,
                                    fontSize: 16,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Gap(30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomContentCardButtons(
                                    image: Assets.imagesCopy,
                                    bgColor: AppColors.iconBgColor,
                                    iconColor: AppColors.iconColor,
                                    onTap: () {
                                      Constants().copyMessage(fact);
                                    },
                                  ),
                                  CustomContentCardButtons(
                                    image: Assets.imagesShare,
                                    bgColor: AppColors.iconBgColor,
                                    iconColor: AppColors.iconColor,
                                    onTap: () {
                                      Constants().shareOther(fact);
                                    },
                                  ),
                                  CustomContentCardButtons(
                                    image: '',
                                    bgColor: AppColors.fevIconBgColor,

                                    widget: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 2,
                                      ),
                                      child: LikeButton(
                                        isLiked: isLiked.value,
                                        padding: EdgeInsets.zero,
                                        onTap: (isLiked) async {
                                          Constants().toggleLike(fact);
                                          return !isLiked;
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: CustomSvgImage(
                                              image: Assets.imagesSaved,
                                              imageColor: isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          );
                                        },
                                        circleColor: CircleColor(
                                          start: Color.fromARGB(
                                            255,
                                            255,
                                            142,
                                            142,
                                          ),
                                          end: Color.fromARGB(
                                            255,
                                            219,
                                            105,
                                            105,
                                          ),
                                        ),
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor: Color.fromARGB(
                                            255,
                                            255,
                                            142,
                                            142,
                                          ),
                                          dotSecondaryColor: Color.fromARGB(
                                            255,
                                            164,
                                            72,
                                            72,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContentCardButtons(
                                    image: Assets.imagesWhatsApp,
                                    bgColor: AppColors.iconBgColor,
                                    iconColor: AppColors.iconColor,
                                    onTap: () {
                                      Constants().shareToWhatsApp(fact);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(fact, fontSize: 16, height: 1.4),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    LikeButton(
                                      size: 30,
                                      isLiked: isLiked.value,
                                      padding: EdgeInsets.zero,
                                      onTap: (isLiked) async {
                                        Constants().toggleLike(fact);
                                        return !isLiked;
                                      },
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isLiked ? Colors.red : null,
                                          size: 26,
                                        );
                                      },
                                      circleColor: CircleColor(
                                        start: Color(0xff00ddff),
                                        end: Color(0xff0099cc),
                                      ),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xff33b5e5),
                                        dotSecondaryColor: Color(0xff0099cc),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        Constants().shareToWhatsApp(fact);
                                      },
                                      child: Image.asset(
                                        Assets.imagesWhatsapp,
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        Constants().exportAndShare(fact);
                                      },
                                      child: Icon(
                                        Icons.share_outlined,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Gap(20);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

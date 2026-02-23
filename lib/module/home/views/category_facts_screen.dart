import 'package:flutter/material.dart';
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Get.back(),
        ),
        title: Obx(
              () => AppText(controller.selectedCategoryName.value,),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: TextField(
              onChanged: controller.searchCategoryFacts,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search,),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

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

              return ListView.builder(
                itemCount: controller.filteredCategoryFacts.length,
                itemBuilder: (_, index) {
                  final fact = controller.filteredCategoryFacts[index];
                  List data = StorageService().read(Constants.likedMessages) ?? [];
                  RxBool isLiked = data.contains(fact).obs;
                  return Padding(
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
                          AppText(
                            fact,
                              fontSize: 16,
                              height: 1.4,

                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children:  [
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
                                        isLiked ? Icons.favorite : Icons.favorite_border,
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
                                    child: Image.asset(Assets.imagesWhatsapp, height: 20),
                                  ),
                                  SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      Constants().exportAndShare(fact);
                                    },
                                    child: Icon(Icons.share_outlined, size: 22,),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/module/home/views/themes_screen.dart';
import 'package:daily_facts/widgets/custom_button.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/theme_model.dart';
import '../../../generated/assets.dart';
import '../../../services/ads/ad_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/app_text.dart';
import '../../setting/views/settings_view.dart';
import '../controllers/fact_controller.dart';
import 'explore_topics_screen.dart';

class FactsReelsScreen extends StatelessWidget {
  final PageController scrollController;
  FactsReelsScreen({super.key, required this.scrollController});

  final FactController controller = Get.put(FactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E6DB),
      body: Obx(() {
        final theme = controller.currentTheme.value;
        if (controller.randomFacts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: BoxDecoration(
            image: theme == null || theme.image.isEmpty
                ? null
                : DecorationImage(
                    image: AssetImage(theme.image),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                itemCount: controller.randomFacts.length,
                itemBuilder: (_, index) {
                  return FactItem(
                    fact: controller.randomFacts[index],
                    // textColor: theme == null ? Colors.white : theme.textColor,
                    textColor: Colors.white,
                    theme: theme,
                  );
                },
              ),

              Positioned(
                bottom: 70,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // _roundIcon(
                    //   Icons.grid_view_rounded,
                    //   onTap: () => Get.to(() => ExploreTopicsScreen()),
                    // ),
                    // Row(
                    //   children: [
                    //     _roundIcon(
                    //       Icons.format_paint_outlined,
                    //       onTap: () => Get.to(() => ThemesScreen()),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     _roundIcon(
                    //       Icons.person_outline,
                    //       onTap: () => Get.to(() => SettingsView()),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   left: 0,
              //   right: 0,
              //   child: AdService().bannerAd == null
              //       ? const SizedBox()
              //       : SizedBox(
              //           height: AdService().bannerAd!.size.height.toDouble(),
              //           width: AdService().bannerAd!.size.width.toDouble(),
              //           child: AdWidget(ad: AdService().bannerAd!),
              //         ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  Widget _roundIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2),
          ],
        ),
        child: Icon(icon, size: 22, color: Colors.black),
      ),
    );
  }
}

class FactItem extends StatelessWidget {
  final String fact;
  final Color textColor;
  final AppThemeModel? theme;

  FactItem({
    super.key,
    required this.fact,
    required this.textColor,
    this.theme,
  });

  final GlobalKey repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List data = StorageService().read(Constants.likedMessages) ?? [];
    RxBool isLiked = data.contains(fact).obs;
    return Stack(
      children: [
        /// FACT TEXT (CENTER)
        Center(
          child: Container(
            key: repaintKey,
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Color(0xFF0D001C),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 2, 43),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: AppText(
                        fact,
                        textAlign: TextAlign.center,
                        fontSize: 22,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContentCardButtons(
                        image: Assets.imagesCopy,
                        bgColor: AppColors.electricPurple.withOpacity(0.5),
                        iconColor: AppColors.electricPurple,
                        onTap: () {
                          Constants().copyMessage(fact);
                        },
                      ),
                      CustomContentCardButtons(
                        image: Assets.imagesShare,
                        bgColor: AppColors.electricPurple.withOpacity(0.5),
                        iconColor: AppColors.electricPurple,
                        onTap: () {
                          Constants().shareOther(fact);
                        },
                      ),
                      CustomContentCardButtons(
                        image: '',
                        bgColor: Colors.red.withOpacity(0.5),

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
                                  imageColor: isLiked ? Colors.red : textColor,
                                ),
                              );
                            },
                            circleColor: CircleColor(
                              start: Color.fromARGB(255, 255, 142, 142),
                              end: Color.fromARGB(255, 219, 105, 105),
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
                        bgColor: AppColors.electricPurple.withOpacity(0.5),
                        iconColor: AppColors.electricPurple,
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
        ),

        /// ACTION ICONS (SCROLL WITH TEXT)
        // Positioned(
        //   bottom: 160,
        //   left: 0,
        //   right: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       InkWell(
        //         onTap: () {
        //           Constants().shareToWhatsApp(fact);
        //         },
        //         child: Container(
        //           padding: EdgeInsets.all(16),
        //           decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: textColor == Colors.white
        //                     ? Colors.black38
        //                     : Colors.white24,
        //                 blurRadius: 25,
        //                 spreadRadius: 5,
        //               ),
        //             ],
        //           ),
        //           child: Image.asset(Assets.imagesWhatsapp, height: 28),
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           Constants().exportAndShare(fact, exportKey: repaintKey);
        //         },
        //         child: Container(
        //           padding: EdgeInsets.all(16),
        //           decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: textColor == Colors.white
        //                     ? Colors.black38
        //                     : Colors.white24,
        //                 blurRadius: 25,
        //                 spreadRadius: 5,
        //               ),
        //             ],
        //           ),
        //           child: Icon(Icons.share_outlined, size: 26, color: textColor),
        //         ),
        //       ),
        //       Container(
        //         decoration: BoxDecoration(
        //           boxShadow: [
        //             BoxShadow(
        //               color: textColor == Colors.white
        //                   ? Colors.black38
        //                   : Colors.white24,
        //               blurRadius: 25,
        //               spreadRadius: 5,
        //             ),
        //           ],
        //         ),
        // child: LikeButton(
        //   size: 41,
        //   isLiked: isLiked.value,
        //   padding: EdgeInsets.zero,
        //   onTap: (isLiked) async {
        //     Constants().toggleLike(fact);
        //     return !isLiked;
        //   },
        //   likeBuilder: (bool isLiked) {
        //     return Icon(
        //       isLiked ? Icons.favorite : Icons.favorite_border,
        //       color: isLiked ? Colors.red : textColor,
        //       size: 30,
        //     );
        //   },
        //   circleColor: CircleColor(
        //     start: Color.fromARGB(255, 255, 142, 142),
        //     end: Color.fromARGB(255, 219, 105, 105),
        //   ),
        //   bubblesColor: BubblesColor(
        //     dotPrimaryColor: Color.fromARGB(255, 255, 142, 142),
        //     dotSecondaryColor: Color.fromARGB(255, 164, 72, 72),
        //   ),
        // ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

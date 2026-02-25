import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../routes/app_routes.dart';
import '../../../services/ads/ad_service.dart';
import '../../../widgets/app_text.dart';
import '../controllers/setting_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingController settingController = Get.find();

  @override
  void initState() {
    AdService.loadNativeBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Obx(
            //   () => SwitchListTile(
            //     contentPadding: EdgeInsets.zero,
            //     title: AppText('Dark Mode', fontWeight: FontWeight.w400),
            //     value: settingController.themeMode.value == ThemeMode.dark,
            //     onChanged: (val) => settingController.toggleTheme(val),
            //   ),
            // ),
            // Divider(height: 30),
            // rowData(
            //   text: "Like",
            //   icon: Icons.favorite_border,
            //   onTap: () {
            //     Get.toNamed(AppRoutes.likedMessagesView);
            //   },
            // ),
            // Divider(height: 30),
            Gap(20),
            Container(
              decoration: BoxDecoration(
                color: AppColors.itemBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: rowData(
                text: "Theme",
                imageColor: Colors.deepPurple,
                image: Assets.imagesTheme,
                onTap: () {
                  Get.toNamed(AppRoutes.themesScreen);
                },
              ),
            ),
            Gap(20),

            // Divider(height: 30),
            // rowData(text: "Remove Ads", icon: Icons.ac_unit),
            Container(
              decoration: BoxDecoration(
                color: AppColors.itemBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  rowData(
                    text: "Privacy policy",
                    image: Assets.imagesPrivacyPolicy,
                    imageColor: Colors.green,

                    onTap: () {
                      settingController.openPrivacyPolicy();
                    },
                  ),
                  Gap(5),
                  rowData(
                    text: "Terms and Conditions",
                    image: Assets.imagesTheme,
                    imageColor: Colors.cyan,

                    onTap: () {
                      settingController.openPrivacyPolicy();
                    },
                  ),
                  Gap(5),
                  rowData(
                    text: "Rate 5 Star",
                    imageColor: Colors.deepOrangeAccent,

                    image: Assets.imagesTheme,

                    onTap: () {
                      settingController.openPlayStore();
                    },
                  ),
                  Gap(5),
                  rowData(
                    text: "Share App",
                    image: Assets.imagesTheme,
                    imageColor: AppColors.iconColor,

                    onTap: () {
                      settingController.shareApp();
                    },
                  ),
                ],
              ),
            ),

            // rowData(
            //   text: "Version",
            //   image: Assets.imagesTheme,

            //   // widget: AppText(
            //   //   "${settingController.version}",
            //   //   fontSize: 18,
            //   //   fontWeight: FontWeight.w400,
            //   // ),
            // ),
            buildNativeAd(),
          ],
        ),
      ),
    );
  }

  Widget buildNativeAd() {
    // return SizedBox();
    return Obx(() {
      if (AdService.isNativeBannerAdLoaded.value &&
          AdService.nativeBannerAd != null) {
        return Container(
          height: 150,
          margin: const EdgeInsets.all(12),
          child: AdWidget(ad: AdService.nativeBannerAd!),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget rowData({
    required String image,
    required String text,
    required Color imageColor,
    void Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      leading: CustomSettingIconView(image: image, color: imageColor),
      title: AppText(text, fontWeight: FontWeight.w400, fontSize: 14),
      trailing: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
    );
  }
}

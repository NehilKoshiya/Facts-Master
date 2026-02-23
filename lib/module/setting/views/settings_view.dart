import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const AppText("Settings"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: AppText('Dark Mode', fontWeight: FontWeight.w400),
                value: settingController.themeMode.value == ThemeMode.dark,
                onChanged: (val) => settingController.toggleTheme(val),
              ),
            ),
            // Divider(height: 30),
            // rowData(
            //   text: "Like",
            //   icon: Icons.favorite_border,
            //   onTap: () {
            //     Get.toNamed(AppRoutes.likedMessagesView);
            //   },
            // ),
            Divider(height: 30),
            rowData(
              text: "Theme",

              widget: CustomSvgImage(image: Assets.imagesTheme),
              onTap: () {
                Get.toNamed(AppRoutes.themesScreen);
              },
            ),
            // Divider(height: 30),
            // rowData(text: "Remove Ads", icon: Icons.ac_unit),
            Divider(height: 30),
            rowData(
              text: "Privacy policy",
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                settingController.openPrivacyPolicy();
              },
            ),
            Divider(height: 30),
            rowData(
              text: "Terms and Conditions",
              icon: Icons.add_moderator_rounded,
              onTap: () {
                settingController.openPrivacyPolicy();
              },
            ),
            Divider(height: 30),
            rowData(
              text: "Rate 5 Star",
              icon: Icons.star_border,
              onTap: () {
                settingController.openPlayStore();
              },
            ),
            Divider(height: 30),
            rowData(
              text: "Share App",
              icon: Icons.share_outlined,
              onTap: () {
                settingController.shareApp();
              },
            ),
            Divider(height: 30),
            rowData(
              text: "Version",
              widget: AppText(
                "${settingController.version}",
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Divider(height: 30),
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
    required String text,
    IconData? icon,
    void Function()? onTap,
    Widget? widget,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text, fontWeight: FontWeight.w400, fontSize: 18),
          icon != null ? Icon(icon, size: 25) : widget ?? SizedBox(),
        ],
      ),
    );
  }
}

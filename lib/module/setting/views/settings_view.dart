import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/module/setting/views/like_screen.dart';
import 'package:daily_facts/services/ads/ad_service.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controllers/setting_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingController settingController = Get.find();
  final AdService adService = AdService();
  static const _settingsNativeKey = 'settings_native_medium';

  @override
  void initState() {
    super.initState();
    adService.loadNative(_settingsNativeKey, templateType: TemplateType.medium);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: customAppBar(
        title: 'Settings',
        context: context,
        toolbarHeight: 82,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: _SettingsBackButton(),
        ),
        titleWidget: const _ModernTopBar(
          title: 'Settings',
          subtitle: 'Control room',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AppAnimatedEntrance(
            child: _SettingsHero(settingController: settingController),
          ),
          const Gap(18),
          AppAnimatedEntrance(
            delay: const Duration(milliseconds: 70),
            child: _SavedFactsPanel(settingController: settingController),
          ),
          const Gap(14),
          AppAnimatedEntrance(
            delay: const Duration(milliseconds: 110),
            child: _SharePanel(settingController: settingController),
          ),
          const Gap(14),
          _buildNativeAd(),
          const Gap(14),
          AppAnimatedEntrance(
            delay: const Duration(milliseconds: 150),
            child: _InfoPanel(settingController: settingController),
          ),
          const Gap(14),
          AppAnimatedEntrance(
            delay: const Duration(milliseconds: 190),
            child: _VersionPanel(settingController: settingController),
          ),
        ],
      ),
    );
  }

  Widget _buildNativeAd() {
    return Obx(() {
      final ad = adService.nativeFor(_settingsNativeKey);
      if (!adService.isNativeLoaded(_settingsNativeKey) || ad == null) {
        return const SizedBox.shrink();
      }

      return AppAnimatedEntrance(
        delay: const Duration(milliseconds: 220),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Sponsored',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).hintColor,
              ),
              const Gap(10),
              SizedBox(
                height: 340,
                width: double.infinity,
                child: AdWidget(ad: ad),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({required this.settingController});

  final SettingController settingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF182033), Color(0xFF0D121D)],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2AE0D3), Color(0xFF6B7CFF)],
                  ),
                ),
                child: const Icon(
                  Icons.settings_suggest_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const AppText(
                  'Dark Control Deck',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Gap(12),
          const AppText(
            'Everything important,\nwithout the clutter.',
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          const Gap(6),
          AppText(
            'Saved facts, sharing, rating, and app info live here now. Categories and themes move out to the main reading flow for faster access.',
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }
}

class _VersionPanel extends StatelessWidget {
  const _VersionPanel({required this.settingController});

  final SettingController settingController;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            'Version',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).hintColor,
          ),
          const Gap(10),
          Obx(
            () => AppText(
              settingController.version.value.isEmpty
                  ? '...'
                  : settingController.version.value,
              textAlign: TextAlign.center,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Gap(6),
          AppText(
            'Installed build on this device',
            textAlign: TextAlign.center,
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }
}

class _SavedFactsPanel extends StatelessWidget {
  const _SavedFactsPanel({required this.settingController});

  final SettingController settingController;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      onTap: () {
        Get.to(
          () => const LikedMessagesView(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(milliseconds: 320),
        );
      },
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(15),
                child: const CustomSvgImage(
                  image: Assets.imagesSaved,
                  imageColor: AppColors.danger,
                  imageHeight: 22,
                  imageWidth: 22,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppText(
                        'Saved Facts',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      const Gap(6),
                      AppText(
                        '${settingController.likedMessages.length} facts kept for later reading.',
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
          const Gap(18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: const AppText(
              'Your favorite facts stay one tap away in a cleaner reading archive.',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharePanel extends StatelessWidget {
  const _SharePanel({required this.settingController});

  final SettingController settingController;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      onTap: settingController.shareApp,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(16),
            child: const CustomSvgImage(
              image: Assets.imagesShare,
              imageColor: AppColors.accent,
              imageHeight: 22,
              imageWidth: 22,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  'Share App',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                const Gap(6),
                AppText(
                  'Invite someone into the same immersive fact stream.',
                  fontSize: 13,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
          ),
          const Icon(Icons.north_east_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.settingController});

  final SettingController settingController;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoRow(
            title: 'Privacy Policy',
            subtitle: 'Read how the app handles your information.',
            icon: Assets.imagesPrivacyPolicy,
            accent: AppColors.success,
            onTap: settingController.openPrivacyPolicy,
          ),
          _InfoRow(
            title: 'Terms and Conditions',
            subtitle: 'See the basic usage terms for the app.',
            icon: Assets.imagesPrivacyPolicy,
            accent: AppColors.secondary,
            onTap: settingController.openTermsAndConditions,
          ),
          _InfoRow(
            title: 'Rate 5 Star',
            subtitle: 'Support the app on the Play Store.',
            icon: Assets.imagesTheme,
            accent: AppColors.warning,
            onTap: settingController.openPlayStore,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            CustomSettingIconView(image: icon, color: accent),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(title, fontWeight: FontWeight.w800, fontSize: 15),
                  const Gap(4),
                  AppText(
                    subtitle,
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernTopBar extends StatelessWidget {
  const _ModernTopBar({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(title, fontSize: 20, fontWeight: FontWeight.w900),
        AppText(subtitle, fontSize: 12, color: Theme.of(context).hintColor),
      ],
    );
  }
}

class _SettingsBackButton extends StatelessWidget {
  const _SettingsBackButton();

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: Get.back,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

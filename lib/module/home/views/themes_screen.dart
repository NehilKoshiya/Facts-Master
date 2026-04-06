import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/data/models/theme_model.dart';
import 'package:daily_facts/module/home/controllers/fact_controller.dart';
import 'package:daily_facts/services/ads/ad_service.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  static const _bannerKey = 'themes_banner';

  final FactController controller = Get.find();
  final AdService adService = AdService();

  @override
  void initState() {
    super.initState();
    adService.loadBanner(_bannerKey);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: customAppBar(
        title: 'Themes',
        context: context,
        toolbarHeight: 82,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: _ThemesBackButton(),
        ),
        titleWidget: const _ThemesTopBar(),
      ),
      body: Obx(() {
        final selectedTheme = controller.currentTheme.value;

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AppAnimatedEntrance(
              child: _SelectedThemePreview(
                theme: selectedTheme ?? controller.themeImages.first,
                label: _themeLabel(
                  selectedTheme ?? controller.themeImages.first,
                ),
              ),
            ),
            const Gap(18),
            AppAnimatedEntrance(
              delay: const Duration(milliseconds: 80),
              child: const AppSectionHeader(
                title: 'Theme Gallery',
                subtitle: 'Tap any card below to apply it instantly.',
              ),
            ),
            const Gap(14),
            Obx(() {
              final banner = adService.bannerFor(_bannerKey);
              if (!adService.isBannerLoaded(_bannerKey) || banner == null) {
                return const SizedBox.shrink();
              }

              return AppAnimatedEntrance(
                delay: const Duration(milliseconds: 110),
                child: Center(
                  child: SizedBox(
                    height: banner.size.height.toDouble(),
                    width: banner.size.width.toDouble(),
                    child: AdWidget(ad: banner),
                  ),
                ),
              );
            }),
            const Gap(16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.themeImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (_, index) {
                final theme = controller.themeImages[index];
                final isSelected =
                    controller.currentTheme.value?.image == theme.image;

                return AppAnimatedEntrance(
                  delay: Duration(milliseconds: 55 * (index % 4)),
                  child: _ThemeGalleryCard(
                    theme: theme,
                    label: _themeLabel(theme),
                    isSelected: isSelected,
                    onTap: () => controller.selectTheme(theme),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  String _themeLabel(AppThemeModel theme) {
    final index = controller.themeImages.indexOf(theme);
    if (theme.image.isEmpty) return 'Default';
    return 'Theme ${index + 1}';
  }
}

class _SelectedThemePreview extends StatelessWidget {
  const _SelectedThemePreview({required this.theme, required this.label});

  final AppThemeModel theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  theme.image.isEmpty
                      ? Container(
                          color: AppColors.darkSurfaceStrong,
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                        )
                      : Image.asset(theme.image, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.18),
                          Colors.black.withValues(alpha: 0.58),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AppText(
                        //   label,
                        //   fontSize: 20,
                        //   fontWeight: FontWeight.w900,
                        //   color: Colors.white,
                        // ),
                        // const Gap(4),
                        AppText(
                          'Currently active on your home feed',
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.76),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeGalleryCard extends StatelessWidget {
  const _ThemeGalleryCard({
    required this.theme,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemeModel theme;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkSurfaceStrong
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.24),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: theme.image.isEmpty
                    ? Container(
                        color: AppColors.darkSurfaceStrong,
                        child: const Center(
                          child: AppText(
                            'Default',
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Image.asset(theme.image, fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.16),
                      Colors.black.withValues(alpha: 0.60),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 220),
                scale: isSelected ? 1 : 0.92,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.black.withValues(alpha: 0.34),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.check_rounded : Icons.add_rounded,
                    size: 18,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  const Gap(4),
                  AppText(
                    isSelected ? 'Selected theme' : 'Tap to apply',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.76),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemesTopBar extends StatelessWidget {
  const _ThemesTopBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppText('Themes', fontSize: 20, fontWeight: FontWeight.w900),
        AppText(
          'Visual mood studio',
          fontSize: 12,
          color: Theme.of(context).hintColor,
        ),
      ],
    );
  }
}

class _ThemesBackButton extends StatelessWidget {
  const _ThemesBackButton();

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

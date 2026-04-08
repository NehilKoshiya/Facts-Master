import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/core/constants/constants.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/services/ads/ad_service.dart';
import 'package:daily_facts/services/storage_service.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';

import '../controllers/fact_controller.dart';

class CategoryFactsScreen extends StatefulWidget {
  const CategoryFactsScreen({super.key});

  @override
  State<CategoryFactsScreen> createState() => _CategoryFactsScreenState();
}

class _CategoryFactsScreenState extends State<CategoryFactsScreen> {
  final FactController controller = Get.find();
  final AdService adService = AdService();
  static const _detailsBannerKey = 'category_details_banner_inline';

  @override
  void initState() {
    super.initState();
    adService.loadBanner(_detailsBannerKey);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final title = controller.selectedCategoryName.value;
      final imagePath = controller.selectedCategoryImage.value;
      final theme = _CategoryDetailsTheme.fromSeed(title);

      return AppScaffold(
        safeTop: true,
        body: Column(
          children: [
            AppAnimatedEntrance(
              child: _CategoryImageHeader(
                title: title,
                imagePath: imagePath,
                theme: theme,
                totalFacts: controller.filteredCategoryFacts.length,
              ),
            ),
            const Gap(12),
            Obx(() {
              final banner = adService.bannerFor(_detailsBannerKey);
              if (!adService.isBannerLoaded(_detailsBannerKey) ||
                  banner == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    AppText(
                      'Sponsored',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).hintColor,
                    ),
                    const Gap(8),
                    SizedBox(
                      height: banner.size.height.toDouble(),
                      width: banner.size.width.toDouble(),
                      child: AdWidget(ad: banner),
                    ),
                  ],
                ),
              );
            }),
            const Gap(14),
            Expanded(
              child: Obx(() {
                if (controller.filteredCategoryFacts.isEmpty) {
                  return _EmptyFactsState(theme: theme);
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: controller.filteredCategoryFacts.length,
                  separatorBuilder: (_, __) => const Gap(14),
                  itemBuilder: (_, index) {
                    final fact = controller.filteredCategoryFacts[index];
                    final data =
                        StorageService().read(Constants.likedMessages) ?? [];
                    final isLiked = data.contains(fact);

                    return AppAnimatedEntrance(
                      delay: Duration(milliseconds: 35 * (index % 6)),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: _FactTimelineCard(
                          index: index,
                          total: controller.filteredCategoryFacts.length,
                          theme: theme,
                          child: _CategoryFactCard(
                            fact: fact,
                            isLiked: isLiked,
                            onCopy: () => Constants().copyMessage(fact),
                            onShare: () => Constants().shareOther(fact),
                            onWhatsApp: () => Constants().shareToWhatsApp(fact),
                            onLike: (liked) async {
                              Constants().toggleLike(fact);
                              return !liked;
                            },
                          ),
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
    });
  }
}

class _CategoryImageHeader extends StatelessWidget {
  const _CategoryImageHeader({
    required this.title,
    required this.imagePath,
    required this.theme,
    required this.totalFacts,
  });

  final String title;
  final String imagePath;
  final _CategoryDetailsTheme theme;
  final int totalFacts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withValues(alpha: 0.18),
            AppColors.darkSurfaceStrong,
            theme.secondary.withValues(alpha: 0.10),
          ],
        ),
        border: Border.all(color: theme.border),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -10,
            child: Container(
              width: 106,
              height: 106,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.secondary.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -18,
            left: -8,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.primary.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CategoryBackButton(),
                      const Spacer(),
                      AppText(title, fontSize: 22, fontWeight: FontWeight.w900),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: AppText(
                          '$totalFacts facts',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: 94,
                  child: _HeroArtwork(
                    imagePath: 'assets/images/$imagePath',
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBackButton extends StatelessWidget {
  const _CategoryBackButton();

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: Get.back,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork({required this.imagePath, required this.theme});

  final String imagePath;
  final _CategoryDetailsTheme theme;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkSurfaceStrong,
              theme.secondary.withValues(alpha: 0.08),
              AppColors.darkSurface,
            ],
          ),
          border: Border.all(color: theme.border),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.primary.withValues(alpha: 0.30),
                      theme.secondary.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    theme.imageTint,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.auto_awesome_rounded,
                      size: 34,
                      color: theme.imageTint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactTimelineCard extends StatelessWidget {
  const _FactTimelineCard({
    required this.index,
    required this.total,
    required this.theme,
    required this.child,
  });

  final int index;
  final int total;
  final _CategoryDetailsTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final number = (index + 1).toString().padLeft(2, '0');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.secondary],
                  ),
                ),
                alignment: Alignment.center,
                child: AppText(
                  number,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (index != total - 1)
                Container(
                  width: 2,
                  height: 74,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.primary.withValues(alpha: 0.38),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Gap(6),
        Expanded(child: child),
      ],
    );
  }
}

class _CategoryFactCard extends StatelessWidget {
  const _CategoryFactCard({
    required this.fact,
    required this.isLiked,
    required this.onLike,
    required this.onCopy,
    required this.onShare,
    this.onWhatsApp,
  });

  final String fact;
  final bool isLiked;
  final Future<bool> Function(bool isLiked) onLike;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      radius: 28,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceStrong,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: AppText(
              fact,
              textAlign: TextAlign.left,
              fontSize: 18,
              height: 1.82,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OverlayActionButton(
                iconWidget: const CustomSvgImage(
                  image: Assets.imagesCopy,
                  imageColor: Colors.white,
                  imageHeight: 19,
                  imageWidth: 19,
                ),
                onTap: onCopy,
                showSuccessFeedback: true,
              ),
              _OverlayActionButton(
                iconWidget: const CustomSvgImage(
                  image: Assets.imagesShare,
                  imageColor: Colors.white,
                  imageHeight: 19,
                  imageWidth: 19,
                ),
                onTap: onShare,
              ),
              if (onWhatsApp != null)
                _OverlayActionButton(
                  iconWidget: const CustomSvgImage(
                    image: Assets.imagesWhatsApp,
                    imageColor: Colors.white,
                    imageHeight: 20,
                    imageWidth: 20,
                  ),
                  onTap: onWhatsApp,
                ),
              _OverlayActionButton(
                iconWidget: LikeButton(
                  isLiked: isLiked,
                  padding: EdgeInsets.zero,
                  size: 22,
                  onTap: onLike,
                  likeBuilder: (liked) {
                    return Icon(
                      liked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: liked ? AppColors.danger : Colors.white,
                      size: 23,
                    );
                  },
                  circleColor: const CircleColor(
                    start: Color(0xFFFFA0AD),
                    end: Color(0xFFFF5977),
                  ),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Color(0xFFFFA0AD),
                    dotSecondaryColor: Color(0xFFFF5977),
                  ),
                ),
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverlayActionButton extends StatefulWidget {
  const _OverlayActionButton({
    required this.iconWidget,
    this.onTap,
    this.showSuccessFeedback = false,
  });

  final Widget iconWidget;
  final VoidCallback? onTap;
  final bool showSuccessFeedback;

  @override
  State<_OverlayActionButton> createState() => _OverlayActionButtonState();
}

class _OverlayActionButtonState extends State<_OverlayActionButton> {
  bool _showCopied = false;

  void _handleTap() {
    widget.onTap?.call();
    if (!widget.showSuccessFeedback) return;

    setState(() => _showCopied = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _showCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _showCopied
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('copied'),
                  color: AppColors.success,
                  size: 24,
                )
              : KeyedSubtree(
                  key: const ValueKey('normal'),
                  child: widget.iconWidget,
                ),
        ),
      ),
    );
  }
}

class _EmptyFactsState extends StatelessWidget {
  const _EmptyFactsState({required this.theme});

  final _CategoryDetailsTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: AppColors.darkSurface,
          border: Border.all(color: theme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primary.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.inbox_rounded, color: theme.primary),
            ),
            const Gap(14),
            const AppText(
              'No facts found',
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            const Gap(6),
            AppText(
              'This category does not have visible facts right now.',
              fontSize: 13,
              color: Theme.of(context).hintColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDetailsTheme {
  const _CategoryDetailsTheme({
    required this.primary,
    required this.secondary,
    required this.border,
    required this.imageTint,
  });

  final Color primary;
  final Color secondary;
  final Color border;
  final Color imageTint;

  static const List<List<Color>> _palettes = [
    [Color(0xFFFF8A65), Color(0xFFFFD54F)],
    [Color(0xFF4FC3F7), Color(0xFF7C4DFF)],
    [Color(0xFF4DB6AC), Color(0xFF81C784)],
    [Color(0xFFF06292), Color(0xFFFFB74D)],
    [Color(0xFF7986CB), Color(0xFF4DD0E1)],
    [Color(0xFFA1887F), Color(0xFFFF8A80)],
    [Color(0xFF64B5F6), Color(0xFFBA68C8)],
    [Color(0xFFFFB74D), Color(0xFFEF5350)],
  ];

  factory _CategoryDetailsTheme.fromSeed(String seed) {
    final palette = _palettes[seed.hashCode.abs() % _palettes.length];
    final primary = palette.first;
    final secondary = palette.last;
    final border = Color.alphaBlend(
      secondary.withValues(alpha: 0.32),
      AppColors.darkBorder,
    );
    final imageTint = Color.alphaBlend(
      primary.withValues(alpha: 0.72),
      const Color(0xFFEAF2FF),
    );

    return _CategoryDetailsTheme(
      primary: primary,
      secondary: secondary,
      border: border,
      imageTint: imageTint,
    );
  }
}

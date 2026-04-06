import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/data/models/fact_model.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_appbar.dart';
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
    return AppScaffold(
      appBar: customAppBar(
        title: 'Categories',
        context: context,
        toolbarHeight: 82,
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: _CategoriesBackButton(),
        ),
        titleWidget: const _CategoriesTopBar(
          title: 'Categories',
          subtitle: 'Visual explorer',
        ),
      ),
      body: Obx(() {
        final groups = controller.factData.value?.data ?? [];

        return ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          children: [
            if (controller.factData.value == null) ...[
              const AppLoadingCard(height: 200),
              const Gap(14),
              const AppLoadingCard(height: 200),
            ] else ...[
              ...List.generate(groups.length, (index) {
                final group = groups[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == groups.length - 1 ? 0 : 18,
                  ),
                  child: AppAnimatedEntrance(
                    delay: Duration(milliseconds: 55 * (index % 5)),
                    child: _CategoryShowcaseSection(
                      group: group,
                      sectionIndex: index,
                      onTapCategory: _openCategory,
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      }),
    );
  }

  void _openCategory(CategoryList category) {
    controller.openCategory(category);
    Get.to(
      () => CategoryFactsScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 420),
    );
    controller.adCount();
  }
}

class _CategoriesTopBar extends StatelessWidget {
  const _CategoriesTopBar({required this.title, required this.subtitle});

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

class _CategoriesBackButton extends StatelessWidget {
  const _CategoriesBackButton();

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

class _CategoryShowcaseSection extends StatelessWidget {
  const _CategoryShowcaseSection({
    required this.group,
    required this.sectionIndex,
    required this.onTapCategory,
  });

  final Datum group;
  final int sectionIndex;
  final ValueChanged<CategoryList> onTapCategory;

  @override
  Widget build(BuildContext context) {
    final sectionTheme = _CategoryTheme.fromSeed(
      '${group.categoryTitleName}-$sectionIndex',
    );
    final spotlight = group.categoryList.isEmpty
        ? null
        : group.categoryList.first;
    final remaining = group.categoryList.length <= 1
        ? <CategoryList>[]
        : group.categoryList.sublist(1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: sectionTheme.background,
        border: Border.all(color: sectionTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [sectionTheme.primary, sectionTheme.secondary],
                  ),
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      group.categoryTitleName,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    const Gap(5),
                    AppText(
                      '${group.categoryList.length} categories with a stronger visual mix',
                      fontSize: 13,
                      color: Theme.of(context).hintColor,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: sectionTheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AppText(
                  'Collection',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: sectionTheme.primary,
                ),
              ),
            ],
          ),
          const Gap(18),
          if (spotlight != null) ...[
            _SpotlightCategoryCard(
              category: spotlight,
              accent: sectionTheme,
              onTap: () => onTapCategory(spotlight),
            ),
            if (remaining.isNotEmpty) const Gap(14),
          ],
          if (remaining.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final columns = isWide ? 3 : 2;
                final spacing = 12.0;
                final itemWidth =
                    (constraints.maxWidth - (spacing * (columns - 1))) /
                    columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: List.generate(remaining.length, (index) {
                    final category = remaining[index];
                    return SizedBox(
                      width: itemWidth,
                      child: _CompactCategoryCard(
                        category: category,
                        onTap: () => onTapCategory(category),
                      ),
                    );
                  }),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SpotlightCategoryCard extends StatelessWidget {
  const _SpotlightCategoryCard({
    required this.category,
    required this.accent,
    required this.onTap,
  });

  final CategoryList category;
  final _CategoryTheme accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = _CategoryTheme.fromSeed(category.categoryName);

    return AppPulseButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primary.withValues(alpha: 0.24),
              accent.secondary.withValues(alpha: 0.10),
              AppColors.darkSurfaceStrong,
            ],
          ),
          border: Border.all(color: theme.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 420;

            return Flex(
              direction: compact ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: compact ? 0 : 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const AppText(
                              'Spotlight',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primary.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: AppText(
                              '${category.facts.length} facts',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      AppText(
                        category.categoryName,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                      const Gap(8),
                      AppText(
                        'A featured category with a larger entrance card, layered color, and direct access into the facts list.',
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ),
                Gap(compact ? 14 : 16),
                SizedBox(
                  width: compact ? double.infinity : 158,
                  child: _CategoryArtwork(
                    imagePath: 'assets/images/${category.categoryImage}',
                    theme: theme,
                    size: compact ? 170 : 158,
                    radius: 26,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CompactCategoryCard extends StatelessWidget {
  const _CompactCategoryCard({required this.category, required this.onTap});

  final CategoryList category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = _CategoryTheme.fromSeed(category.categoryName);

    return AppPulseButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: AppColors.darkSurface,
          border: Border.all(color: theme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryArtwork(
              imagePath: 'assets/images/${category.categoryImage}',
              theme: theme,
              size: 122,
              radius: 22,
            ),
            const Gap(12),
            AppText(
              category.categoryName,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(4),
            AppText(
              '${category.facts.length} facts inside',
              fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryArtwork extends StatelessWidget {
  const _CategoryArtwork({
    required this.imagePath,
    required this.theme,
    required this.size,
    required this.radius,
  });

  final String imagePath;
  final _CategoryTheme theme;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withValues(alpha: 0.16),
            theme.secondary.withValues(alpha: 0.12),
            AppColors.darkSurfaceStrong,
          ],
        ),
        border: Border.all(color: theme.border.withValues(alpha: 0.92)),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 0,
            child: Container(
              width: size * 0.48,
              height: size * 0.48,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    theme.secondary.withValues(alpha: 0.28),
                    theme.secondary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            left: -2,
            child: Container(
              width: size * 0.40,
              height: size * 0.40,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    theme.primary.withValues(alpha: 0.30),
                    theme.primary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius - 6),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkSurfaceStrong,
                    theme.innerSurface,
                    AppColors.darkSurface,
                  ],
                ),
                border: Border.all(color: theme.innerBorder),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: size * 0.72,
                      height: size * 0.72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.primaryGlow,
                            theme.secondaryGlow,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size * 0.12),
                    child: Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          theme.imageTint,
                          BlendMode.srcIn,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withValues(alpha: 0.24),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.auto_awesome_rounded,
                              color: theme.imageTint,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
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

class _CategoryTheme {
  const _CategoryTheme({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.border,
    required this.innerSurface,
    required this.innerBorder,
    required this.imageTint,
    required this.primaryGlow,
    required this.secondaryGlow,
  });

  final Color primary;
  final Color secondary;
  final Color background;
  final Color border;
  final Color innerSurface;
  final Color innerBorder;
  final Color imageTint;
  final Color primaryGlow;
  final Color secondaryGlow;

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

  factory _CategoryTheme.fromSeed(String seed) {
    final palette = _palettes[seed.hashCode.abs() % _palettes.length];
    final primary = palette.first;
    final secondary = palette.last;
    final background = Color.alphaBlend(
      primary.withValues(alpha: 0.08),
      AppColors.darkSurface,
    );
    final border = Color.alphaBlend(
      secondary.withValues(alpha: 0.34),
      AppColors.darkBorder,
    );
    final imageTint = Color.alphaBlend(
      primary.withValues(alpha: 0.72),
      const Color(0xFFEAF2FF),
    );
    final innerSurface = Color.alphaBlend(
      secondary.withValues(alpha: 0.12),
      const Color(0xFF121A29),
    );
    final innerBorder = Color.alphaBlend(
      primary.withValues(alpha: 0.24),
      const Color(0x335E6A85),
    );
    final primaryGlow = primary.withValues(alpha: 0.24);
    final secondaryGlow = secondary.withValues(alpha: 0.14);

    return _CategoryTheme(
      primary: primary,
      secondary: secondary,
      background: background,
      border: border,
      innerSurface: innerSurface,
      innerBorder: innerBorder,
      imageTint: imageTint,
      primaryGlow: primaryGlow,
      secondaryGlow: secondaryGlow,
    );
  }
}

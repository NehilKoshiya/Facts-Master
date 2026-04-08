import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/core/constants/constants.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/module/home/views/explore_topics_screen.dart';
import 'package:daily_facts/module/home/views/themes_screen.dart';
import 'package:daily_facts/module/setting/views/settings_view.dart';
import 'package:daily_facts/services/storage_service.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

import '../controllers/fact_controller.dart';

class FactsReelsScreen extends StatefulWidget {
  const FactsReelsScreen({super.key});

  @override
  State<FactsReelsScreen> createState() => _FactsReelsScreenState();
}

class _FactsReelsScreenState extends State<FactsReelsScreen> {
  final FactController controller = Get.find<FactController>();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _didPrecacheThemes = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheThemes) return;

    for (final theme in controller.themeImages) {
      if (theme.image.isNotEmpty) {
        precacheImage(AssetImage(theme.image), context);
      }
    }

    _didPrecacheThemes = true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: false,
      padding: EdgeInsets.zero,
      body: Obx(() {
        final currentTheme = controller.currentTheme.value;
        final facts = controller.randomFacts;

        if (facts.isEmpty) {
          return const Center(child: AppLoadingCard(height: 520));
        }

        if (_currentIndex >= facts.length) {
          _currentIndex = 0;
        }

        final currentFact = facts[_currentIndex];
        final likedFacts = List<String>.from(
          StorageService().read(Constants.likedMessages) ?? [],
        );
        final isLiked = likedFacts.contains(currentFact);

        return Stack(
          children: [
            Positioned.fill(
              child: currentTheme != null && currentTheme.image.isNotEmpty
                  ? Image.asset(
                      currentTheme.image,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.low,
                    )
                  : Container(color: AppColors.darkSurfaceStrong),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.16),
                      Colors.black.withValues(alpha: 0.24),
                      Colors.black.withValues(alpha: 0.34),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          padEnds: false,
                          itemCount: facts.length,
                          onPageChanged: (index) {
                            if (_currentIndex != index) {
                              setState(() => _currentIndex = index);
                            }
                          },
                          itemBuilder: (_, index) {
                            return _StoryFactPage(fact: facts[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 18,
                    right: 20,
                    child: AppAnimatedEntrance(
                      offset: const Offset(0, -14),
                      duration: const Duration(milliseconds: 520),
                      child: Row(
                        children: [
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesCategory,
                              imageColor: Colors.white,
                              imageHeight: 18,
                              imageWidth: 18,
                            ),
                            onTap: () {
                              Get.to(
                                () => ExploreTopicsScreen(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 320),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesTheme,
                              imageColor: Colors.white,
                              imageHeight: 18,
                              imageWidth: 18,
                            ),
                            onTap: () {
                              Get.to(
                                () => ThemesScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 280),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesSetting,
                              imageColor: Colors.white,
                              imageHeight: 18,
                              imageWidth: 18,
                            ),
                            onTap: () {
                              Get.to(
                                () => const SettingsView(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 320),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: AppAnimatedEntrance(
                      offset: const Offset(0, 16),
                      duration: const Duration(milliseconds: 520),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesCopy,
                              imageColor: Colors.white,
                              imageHeight: 20,
                              imageWidth: 20,
                            ),
                            onTap: () => Constants().copyMessage(currentFact),
                            showSuccessFeedback: true,
                          ),
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesShare,
                              imageColor: Colors.white,
                              imageHeight: 20,
                              imageWidth: 20,
                            ),
                            onTap: () => Constants().shareOther(currentFact),
                          ),
                          _OverlayIconButton(
                            iconWidget: const CustomSvgImage(
                              image: Assets.imagesWhatsApp,
                              imageColor: Colors.white,
                              imageHeight: 21,
                              imageWidth: 21,
                            ),
                            onTap: () =>
                                Constants().shareToWhatsApp(currentFact),
                          ),
                          _OverlayIconButton(
                            iconWidget: LikeButton(
                              isLiked: isLiked,
                              padding: EdgeInsets.zero,
                              size: 22,
                              onTap: (liked) async {
                                Constants().toggleLike(currentFact);
                                if (mounted) {
                                  setState(() {});
                                }
                                return !liked;
                              },
                              likeBuilder: (liked) {
                                return Icon(
                                  liked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: liked
                                      ? AppColors.danger
                                      : Colors.white,
                                  size: 24,
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StoryFactPage extends StatelessWidget {
  const _StoryFactPage({required this.fact});

  final String fact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 88, 20, 110),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              fact,
              key: ValueKey(fact),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1.35,
                letterSpacing: 0.2,
                fontFamily: 'DM Sans',
                shadows: [Shadow(color: Color(0x96000000), blurRadius: 18)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayIconButton extends StatefulWidget {
  const _OverlayIconButton({
    required this.iconWidget,
    required this.onTap,
    this.showSuccessFeedback = false,
  });

  final Widget iconWidget;
  final VoidCallback? onTap;
  final bool showSuccessFeedback;

  @override
  State<_OverlayIconButton> createState() => _OverlayIconButtonState();
}

class _OverlayIconButtonState extends State<_OverlayIconButton> {
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
    final button = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Center(
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

    if (widget.onTap == null) {
      return button;
    }

    return AppPulseButton(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(18),
      child: button,
    );
  }
}

import 'dart:math' as math;

import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../controllers/fact_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _floatController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _contentSlide;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.58, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.78, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.08, 0.62, curve: Curves.easeOutBack),
      ),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.20, 0.82, curve: Curves.easeOutCubic),
          ),
        );

    _introController.forward();
    _prepareAndNavigate();
  }

  Future<void> _prepareAndNavigate() async {
    final controller = Get.isRegistered<FactController>()
        ? Get.find<FactController>()
        : Get.put(FactController(), permanent: true);

    final splashDelay = Future<void>.delayed(
      const Duration(milliseconds: 2400),
    );

    if (controller.randomFacts.isEmpty) {
      await controller.loadFacts();
    }

    final currentTheme = controller.currentTheme.value;
    if (mounted && currentTheme != null && currentTheme.image.isNotEmpty) {
      await precacheImage(AssetImage(currentTheme.image), context);
    }

    await splashDelay;

    if (!mounted || _navigated) return;
    _navigated = true;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.darkBackgroundGradient,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, _) {
                  final wave = math.sin(_floatController.value * math.pi * 2);
                  return Stack(
                    children: [
                      Positioned(
                        top: -90 + (wave * 10),
                        right: -50,
                        child: _GlowOrb(
                          size: 250,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.24),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -120 - (wave * 8),
                        left: -70,
                        child: _GlowOrb(
                          size: 280,
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      Positioned(
                        top: 180 - (wave * 14),
                        left: 24,
                        child: Transform.rotate(
                          angle: -0.16,
                          child: _GlassRibbon(color: AppColors.accent),
                        ),
                      ),
                      Positioned(
                        bottom: 150 + (wave * 12),
                        right: 20,
                        child: Transform.rotate(
                          angle: 0.22,
                          child: _GlassRibbon(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _logoScale,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 178,
                                  height: 178,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.primary.withValues(
                                          alpha: 0.22,
                                        ),
                                        AppColors.secondary.withValues(
                                          alpha: 0.10,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 148,
                                  height: 148,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.10),
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.14,
                                        ),
                                        blurRadius: 26,
                                        offset: const Offset(0, 14),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.darkSurfaceStrong,
                                          AppColors.darkSurface,
                                        ],
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        Assets.imagesAppLogo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          const AppText(
                            'Fact Master',
                            fontWeight: FontWeight.w900,
                            fontSize: 34,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          AppText(
                            'Fast facts, beautiful categories, and a smoother dark reading flow.',
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.76),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 120,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedBuilder(
                                animation: _introController,
                                builder: (context, _) {
                                  return FractionallySizedBox(
                                    widthFactor:
                                        0.18 + (_introController.value * 0.82),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.secondary,
                                            AppColors.primary,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _GlassRibbon extends StatelessWidget {
  const _GlassRibbon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
    );
  }
}

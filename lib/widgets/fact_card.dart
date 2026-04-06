import 'dart:async';

import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/generated/assets.dart';
import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/app_surfaces.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:like_button/like_button.dart';

class FactCard extends StatelessWidget {
  const FactCard({
    super.key,
    required this.fact,
    required this.isLiked,
    required this.onLike,
    required this.onCopy,
    required this.onShare,
    this.onWhatsApp,
    this.textColor = Colors.white,
    this.compact = false,
    this.useAnimatedLike = true,
  });

  final String fact;
  final bool isLiked;
  final Future<bool> Function(bool isLiked) onLike;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback? onWhatsApp;
  final Color textColor;
  final bool compact;
  final bool useAnimatedLike;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      radius: compact ? 24 : 32,
      padding: EdgeInsets.all(compact ? 16 : 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(compact ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceStrong,
              borderRadius: BorderRadius.circular(compact ? 24 : 28),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: AppText(
              fact,
              textAlign: TextAlign.center,
              fontSize: compact ? 16 : 26,
              height: 1.65,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Gap(compact ? 18 : 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FactActionButton(
                image: Assets.imagesCopy,
                onTap: onCopy,
                semanticLabel: 'Copy fact',
                showSuccessFeedback: true,
              ),
              FactActionButton(
                image: Assets.imagesShare,
                onTap: onShare,
                semanticLabel: 'Share fact',
              ),
              FactActionButton(
                onTap: null,
                semanticLabel: 'Save fact',
                child: useAnimatedLike
                    ? LikeButton(
                        isLiked: isLiked,
                        padding: EdgeInsets.zero,
                        size: 22,
                        onTap: onLike,
                        likeBuilder: (isLiked) {
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: CustomSvgImage(
                              image: Assets.imagesSaved,
                              imageColor: isLiked
                                  ? AppColors.danger
                                  : textColor,
                              imageHeight: 18,
                              imageWidth: 18,
                            ),
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
                      )
                    : InkWell(
                        onTap: () => onLike(isLiked),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: CustomSvgImage(
                            image: Assets.imagesSaved,
                            imageColor: isLiked ? AppColors.danger : textColor,
                            imageHeight: 18,
                            imageWidth: 18,
                          ),
                        ),
                      ),
              ),
              if (onWhatsApp != null)
                FactActionButton(
                  image: Assets.imagesWhatsApp,
                  onTap: onWhatsApp,
                  semanticLabel: 'Share to WhatsApp',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class FactActionButton extends StatefulWidget {
  const FactActionButton({
    super.key,
    this.image,
    required this.semanticLabel,
    this.onTap,
    this.child,
    this.showSuccessFeedback = false,
  });

  final String? image;
  final String semanticLabel;
  final VoidCallback? onTap;
  final Widget? child;
  final bool showSuccessFeedback;

  @override
  State<FactActionButton> createState() => _FactActionButtonState();
}

class _FactActionButtonState extends State<FactActionButton> {
  Timer? _resetTimer;
  bool _showCopied = false;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap?.call();
    if (!widget.showSuccessFeedback) return;

    _resetTimer?.cancel();
    if (mounted) {
      setState(() => _showCopied = true);
    }
    _resetTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _showCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild =
        widget.child ??
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _showCopied
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('copied'),
                  color: AppColors.success,
                  size: 20,
                )
              : CustomSvgImage(
                  key: ValueKey(widget.image ?? widget.semanticLabel),
                  image: widget.image!,
                  imageColor: AppColors.iconColor,
                  imageHeight: 18,
                  imageWidth: 18,
                ),
        );

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: AppPulseButton(
        onTap: _handleTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.iconBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: buttonChild,
        ),
      ),
    );
  }
}

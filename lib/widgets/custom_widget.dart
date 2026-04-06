import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class CustomSvgImage extends StatelessWidget {
  final String image;
  final Color? imageColor;
  final double? imageHeight;
  final double? imageWidth;

  const CustomSvgImage({
    super.key,
    required this.image,
    this.imageColor,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      colorFilter: imageColor == null
          ? null
          : ColorFilter.mode(imageColor!, BlendMode.srcIn),
      height: imageHeight,
      width: imageWidth,
    );
  }
}

class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: AppColors.brandGradient,
      ),
    );
  }
}

class CustomAppNameHeader extends StatelessWidget {
  const CustomAppNameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'Fact Master',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkTextPrimary,
                ),
                AppText(
                  'Fresh facts. Dark mood. Better reading flow.',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkTextSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSettingIconView extends StatelessWidget {
  final String image;
  final Color color;

  const CustomSettingIconView({
    super.key,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(10),
      child: CustomSvgImage(
        image: image,
        imageColor: color,
        imageHeight: 16,
        imageWidth: 16,
      ),
    );
  }
}

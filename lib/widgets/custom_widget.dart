import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          : ColorFilter.mode(
              imageColor ?? AppColors.transparent,
              BlendMode.srcIn,
            ),
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
      width: 5, // thickness of the line
      height: 28, // adjust height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

        color: AppColors.iconColor,
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
        color: AppColors.itemBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: AppText(
        'Hey Fact Master - Brain Bites..!',
        fontSize: 16,
        fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      padding: EdgeInsets.all(8),
      child: CustomSvgImage(
        image: image,
        imageColor: Colors.white,
        imageHeight: 15,
        imageWidth: 15,
      ),
    );
  }
}

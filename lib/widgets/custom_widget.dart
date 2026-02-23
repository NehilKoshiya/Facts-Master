import 'package:daily_facts/core/constants/app_colors.dart';
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

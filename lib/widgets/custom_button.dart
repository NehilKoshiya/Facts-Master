import 'package:daily_facts/widgets/app_motion.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C5CFF), Color(0xFF00C2A8)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class CustomContentCardButtons extends StatelessWidget {
  final String image;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? widget;

  const CustomContentCardButtons({
    super.key,
    required this.image,
    this.bgColor,
    this.iconColor,
    this.onTap,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return AppPulseButton(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            widget ??
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomSvgImage(
                image: image,
                imageColor: iconColor,
                imageHeight: 18,
                imageWidth: 18,
              ),
            ),
      ),
    );
  }
}

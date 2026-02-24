import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
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
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child:
            widget ??
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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

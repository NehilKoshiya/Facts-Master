import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
        height: height,
      ),
    );
  }
}

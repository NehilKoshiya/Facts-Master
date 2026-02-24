import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;

  final BorderSide? focusBorderSide;

  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final bool readOnly;

  final Function(String)? onChanged;
  final TextEditingController? controller;

  final void Function()? textFiledOnTap;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatter;
  final int maxLine;
  final double? width;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String prefixImage;
  final String suffixImage;
  final Color? prefixColor;
  final Color? suffixColor;
  final Color? fillColor;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.hintText,
    this.fillColor,

    this.focusBorderSide,
    this.focusNode,
    this.prefixColor,
    this.suffixColor,

    this.prefixIcon,
    this.suffixIcon,

    this.keyboardType,
    this.controller,
    this.width,
    this.borderColor,

    this.padding,
    this.readOnly = false,
    this.textFiledOnTap,
    this.onChanged,
    this.maxLine = 1,
    this.inputFormatter,
    this.obscureText = false,
    this.prefixImage = '',
    this.suffixImage = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,

      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode,
      cursorColor: AppColors.darkSoftBg,
      onTap: textFiledOnTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      maxLines: maxLine,
      inputFormatters: inputFormatter ?? [],
      minLines: maxLine,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: AppColors.darkSoftBg,
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,

        filled: true,
        fillColor: fillColor ?? Color.fromARGB(255, 21, 2, 43),
        contentPadding:
            padding ??
            EdgeInsets.symmetric(horizontal: prefixImage == '' ? 15 : 24),

        hintStyle: TextStyle(
          fontFamily: 'DM Sans',
          color: AppColors.darkTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),

        // labelText: labelText,
        // labelStyle: TextStyle(
        //   fontFamily: 'DM Sans',
        //   color: ColorConstants.grey400Color,
        //   fontSize: 16,
        //   fontWeight: FontWeight.w500,
        // ),
        prefixIcon: prefixImage == ''
            ? prefixIcon
            : CustomTextFiledIcon(
                image: prefixImage,
                color: prefixColor ?? AppColors.darkSoftBg,
              ),
        suffixIcon: suffixImage == ''
            ? suffixIcon
            : CustomTextFiledIcon(image: suffixImage, color: suffixColor),
        border: border(),
        disabledBorder: border(),
        enabledBorder: border(),
        focusedBorder: border(
          borderSide:
              focusBorderSide ?? BorderSide(color: AppColors.darkSoftBg),
        ),
      ),
    );
  }
}

OutlineInputBorder border({BorderSide? borderSide}) {
  return OutlineInputBorder(
    borderSide: borderSide ?? BorderSide(color: AppColors.darkTextSecondary),
    borderRadius: BorderRadius.circular(20),
  );
}

class CustomTextFiledIcon extends StatelessWidget {
  final String image;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  const CustomTextFiledIcon({
    super.key,
    required this.image,
    this.padding,
    this.onTap,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: CustomSvgImage(
            image: image,
            imageHeight: 24,
            imageWidth: 24,
            imageColor: color,
          ),
        ),
      ),
    );
  }
}

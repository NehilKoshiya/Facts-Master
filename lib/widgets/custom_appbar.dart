import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:daily_facts/widgets/app_text.dart';
import 'package:daily_facts/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

AppBar customAppBar({
  required String title,
  required BuildContext context,
  Color? backgroundColor,
  Widget? leading,
  List<Widget>? actions,
  double? fontSize,
  bool? centerTitle,
  FontWeight? fontWeight,
  double? leadingWidth,
  PreferredSizeWidget? bottom,
  double? toolbarHeight,

  Widget? titleWidget,
}) {
  return AppBar(
    backgroundColor: AppColors.bgColor,
    surfaceTintColor: AppColors.bgColor,
    elevation: 0,

    title:
        titleWidget ??
        AppText(
          title,
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: Colors.white,
        ),
    iconTheme: const IconThemeData(
      color: Colors.white, // 👈 Change back button color here
    ),
    centerTitle: centerTitle ?? false,
    toolbarHeight: toolbarHeight ?? 50,
    leadingWidth: leadingWidth,
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}

AppBar mainAppBar({required BuildContext context, Color? color}) {
  return customAppBar(
    titleWidget: CustomAppNameHeader(),

    title: '',
    context: context,
  );
}

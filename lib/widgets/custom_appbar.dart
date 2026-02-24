import 'package:daily_facts/widgets/app_text.dart';
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
    elevation: 0,

    title:
        titleWidget ??
        AppText(
          title,
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w700,
        ),
    centerTitle: centerTitle ?? true,
    toolbarHeight: toolbarHeight ?? 50,
    leadingWidth: leadingWidth,
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}

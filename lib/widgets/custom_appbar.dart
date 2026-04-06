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
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    title:
        titleWidget ??
        AppText(
          title,
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w800,
          color: theme.colorScheme.onSurface,
        ),
    iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    centerTitle: centerTitle ?? false,
    toolbarHeight: toolbarHeight ?? 64,
    leadingWidth: leadingWidth,
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}

AppBar mainAppBar({required BuildContext context, Color? color}) {
  return customAppBar(
    titleWidget: const CustomAppNameHeader(),
    title: '',
    context: context,
  );
}

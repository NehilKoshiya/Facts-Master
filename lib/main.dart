import 'package:daily_facts/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'module/setting/controllers/setting_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SettingController _themeController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fact Master - Brain Bites',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeController.themeMode.value,
    );
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightPrimaryBg,

  primaryColor: AppColors.neonPink,
  hintColor: AppColors.neonPink,

  colorScheme: const ColorScheme.light(
    surface: AppColors.lightPinkTint,
    primary: AppColors.neonPink,
    secondary: AppColors.electricPurple,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    titleLarge: TextStyle(color: AppColors.lightTextPrimary),
    titleMedium: TextStyle(color: AppColors.lightTextSecondary),
  ),

  primarySwatch: Colors.blue,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
  ),

  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontSize: 16,
    ),
    subtitleTextStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontSize: 14,
    ),
  ),

  dividerTheme: DividerThemeData(
    color: AppColors.lightTextSecondary.withValues(alpha: 0.2),
    thickness: 1,
    space: 32,
  ),

  // textTheme: TextTheme(
  //   displayLarge: TextStyle(),
  //   displayMedium: TextStyle(),
  //   displaySmall: TextStyle(),
  //   headlineLarge: TextStyle(),
  //   headlineMedium: TextStyle(),
  //   headlineSmall: TextStyle(),
  //   titleLarge: TextStyle(),
  //   titleMedium: TextStyle(),
  //   titleSmall: TextStyle(),
  //   bodyLarge: TextStyle(),
  //   bodyMedium: TextStyle(),
  //   bodySmall: TextStyle(),
  //   labelLarge: TextStyle(),
  //   labelMedium: TextStyle(),
  //   labelSmall: TextStyle(),
  // ),
  cardColor: Color(0xffF7F7F8),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkPrimaryBg,

  primaryColor: AppColors.neonPink,
  hintColor: AppColors.hotPink,

  colorScheme: const ColorScheme.dark(
    surface: AppColors.darkSoftBg,
    primary: AppColors.neonPink,
    secondary: AppColors.electricPurple,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
    titleLarge: TextStyle(color: AppColors.darkTextPrimary),
    titleMedium: TextStyle(color: AppColors.darkTextSecondary),
  ),

  primarySwatch: Colors.indigo,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.black,
    backgroundColor: Colors.black,
  ),

  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(color: AppColors.darkTextSecondary, fontSize: 16),
    subtitleTextStyle: TextStyle(
      color: AppColors.darkTextSecondary,
      fontSize: 14,
    ),
  ),

  dividerTheme: DividerThemeData(
    color: AppColors.darkTextSecondary.withValues(alpha: 0.3),
    thickness: 1,
    space: 32,
  ),

  // textTheme: TextTheme(
  //   displayLarge: TextStyle(),
  //   displayMedium: TextStyle(),
  //   displaySmall: TextStyle(),
  //   headlineLarge: TextStyle(),
  //   headlineMedium: TextStyle(),
  //   headlineSmall: TextStyle(),
  //   titleLarge: TextStyle(),
  //   titleMedium: TextStyle(),
  //   titleSmall: TextStyle(),
  //   bodyLarge: TextStyle(),
  //   bodyMedium: TextStyle(),
  //   bodySmall: TextStyle(),
  //   labelLarge: TextStyle(),
  //   labelMedium: TextStyle(),
  //   labelSmall: TextStyle(),
  // ),
  cardColor: Color(0xff232627),
);

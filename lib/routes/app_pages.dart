import 'package:daily_facts/module/home/views/bottom_navigation_bar_screen.dart';
import 'package:daily_facts/module/home/views/themes_screen.dart';
import 'package:get/get.dart';
import '../module/home/views/home_view.dart';
import '../module/home/views/splash_screen.dart';
import '../module/setting/views/like_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.home, page: () => MainScreen()),
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    // GetPage(name: AppRoutes.likedMessagesView, page: () => LikedMessagesView()),
    GetPage(name: AppRoutes.themesScreen, page: () => ThemesScreen()),
  ];
}

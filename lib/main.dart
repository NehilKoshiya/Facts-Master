import 'package:daily_facts/firebase_options.dart';
import 'package:daily_facts/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/theme/app_theme.dart';
import 'services/notifications/one_signal_service.dart';
import 'services/ads/ad_service.dart';
import 'module/setting/controllers/setting_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await AdService().initialize();
  await OneSignalService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    Get.put(SettingController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fact Master - Brain Bites',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}

import 'package:daily_facts/services/ads/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/constants.dart';
import '../../../services/storage_service.dart';

class SettingController extends GetxController {
  final StorageService _storage = StorageService();
  final themeMode = ThemeMode.system.obs;
  final storage = StorageService();
  RxList<String> likedMessages = <String>[].obs;
  RxString version = "".obs;

  @override
  void onInit() {
    super.onInit();
    bool? isDark = _storage.read('isDarkMode');
    themeMode.value = (isDark ?? false) ? ThemeMode.dark : ThemeMode.light;
    loadStoredData();
    getVersion();
  }

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    _storage.write('isDarkMode', isDark);
  }

  void loadStoredData() {
    likedMessages.value =
    List<String>.from(storage.read<List>(Constants.likedMessages) ?? []);
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Copied", "Message copied!");
  }

  void shareText(String text) {
    // Share.share(text);
  }

    getVersion() async {
    final info = await PackageInfo.fromPlatform();
    version.value = "${info.version} (${info.buildNumber})";
    update();
  }

  void openPlayStore() async {
    final packageName = "com.app.factmaster.brainbites";
    final url = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // fallback if not available
      print("Cannot open Play Store");
    }
  }

  void shareApp() {
    final packageName = "com.app.factmaster.brainbites";
    final appUrl = "https://play.google.com/store/apps/details?id=$packageName";

    final text = "Hey! Check out this awesome app: $appUrl";

    Share.share(text);
  }

  void openPrivacyPolicy() async {
    final url = Uri.parse("https://flirt-master-f7842.web.app/privacy.html");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch Privacy Policy URL");
    }
  }
}

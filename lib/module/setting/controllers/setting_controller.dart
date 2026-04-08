import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/constants.dart';
import '../views/legal_info_screen.dart';
import '../../../services/storage_service.dart';

class SettingController extends GetxController {
  final StorageService _storage = StorageService();
  final themeMode = ThemeMode.dark.obs;
  final storage = StorageService();
  RxList<String> likedMessages = <String>[].obs;
  RxString version = "".obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
    _storage.write('isDarkMode', true);
    loadStoredData();
    getVersion();
  }

  void toggleTheme(bool isDark) {
    themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
    _storage.write('isDarkMode', true);
  }

  void loadStoredData() {
    likedMessages.value = List<String>.from(
      storage.read<List>(Constants.likedMessages) ?? [],
    );
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
    final url = Uri.parse(Constants.appStoreUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Cannot open Play Store");
    }
  }

  void shareApp() {
    final text = Constants().buildAppShareMessage();
    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Check out Fact Master - Brain Bites',
      ),
    );
  }

  void openPrivacyPolicy() async {
    Get.to(
      () => const LegalInfoScreen(
        title: 'Privacy Policy',
        subtitle: 'Data and permissions',
        heroTitle: 'Your privacy inside Fact Master.',
        heroDescription:
            'This policy explains what the app stores on your device, what third-party services may be used, and how basic app features handle your information.',
        icon: Icons.privacy_tip_rounded,
        accent: Color(0xFF2DCB8C),
        sections: [
          LegalSectionData(
            title: 'Information We Store',
            points: [
              'Fact Master may store your selected theme, saved facts, and other simple app preferences locally on your device so the experience feels personal and consistent.',
              'This app does not ask you to create an account, and it does not require personal profile details such as your name, email address, or phone number to use the main reading experience.',
            ],
          ),
          LegalSectionData(
            title: 'How The App Uses Data',
            points: [
              'Saved facts and theme choices are used only to support features inside the app, such as favorites, reading continuity, and visual customization.',
              'When you use sharing features, the content you choose to share is passed to the external app or platform you select, based on your own action.',
            ],
          ),
          LegalSectionData(
            title: 'Advertising and Analytics',
            points: [
              'Fact Master may display ads using third-party advertising services such as Google Mobile Ads. Those services may collect technical and device-related information according to their own policies.',
              'Ad-related services may use identifiers, diagnostics, and performance data to serve, measure, and improve advertising delivery.',
            ],
          ),
          LegalSectionData(
            title: 'Permissions and External Links',
            points: [
              'The app may open external destinations such as app store pages, share sheets, or social apps only when you explicitly choose those actions.',
              'Any external site or service opened from the app is governed by its own privacy practices and terms.',
            ],
          ),
          LegalSectionData(
            title: 'Policy Updates',
            points: [
              'This privacy policy may be updated over time to reflect product changes, legal updates, or service integrations.',
              'By continuing to use the app, you agree to the latest in-app version of this policy.',
            ],
          ),
        ],
      ),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 320),
    );
  }

  void openTermsAndConditions() {
    Get.to(
      () => const LegalInfoScreen(
        title: 'Terms & Conditions',
        subtitle: 'Usage rules',
        heroTitle: 'Simple rules for using Fact Master.',
        heroDescription:
            'These terms describe the basic conditions for using the app, interacting with its content, and understanding the limits of service and responsibility.',
        icon: Icons.gavel_rounded,
        accent: Color(0xFF2DD4BF),
        sections: [
          LegalSectionData(
            title: 'App Use',
            points: [
              'Fact Master is provided for personal, informational, and entertainment use. You agree to use the app lawfully and in a way that does not interfere with normal service operation.',
              'You are responsible for how you use copied or shared content after it leaves the app.',
            ],
          ),
          LegalSectionData(
            title: 'Content Disclaimer',
            points: [
              'The app presents fact-based and curiosity-driven content for general reading. While care may be taken in preparing content, Fact Master does not guarantee that every fact is complete, current, or error-free at all times.',
              'The app should not be treated as legal, medical, financial, or professional advice.',
            ],
          ),
          LegalSectionData(
            title: 'Intellectual Property',
            points: [
              'The app design, branding, interface, and compiled content experience remain the property of the app owner or the respective rights holders.',
              'You may share facts using the app’s built-in tools for normal personal use, but you should not repackage the application itself, reverse engineer protected parts, or distribute modified copies without permission.',
            ],
          ),
          LegalSectionData(
            title: 'Ads and Third-Party Services',
            points: [
              'Fact Master may include advertisements, app store links, and third-party integrations. Those services operate under their own policies and availability.',
              'The app is not responsible for the content, behavior, or service quality of third-party platforms opened from within the app.',
            ],
          ),
          LegalSectionData(
            title: 'Availability and Liability',
            points: [
              'Features, content, and screen designs may change, be paused, or be removed at any time without prior notice.',
              'To the maximum extent allowed by law, Fact Master is provided as-is and the app owner is not liable for indirect loss, interruption, or compatibility issues arising from app use.',
            ],
          ),
        ],
      ),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 320),
    );
  }
}

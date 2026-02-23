import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  /// Initialize Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // -------------------------------
  // TEST AD UNIT IDS
  // -------------------------------
  // final String bannerAdUnit = Platform.isAndroid ? "ca-app-pub-5627324410826009~5563575952" : "ca-app-pub-5627324410826009/9827072839";
  // final String interstitialAdUnit = Platform.isAndroid ? "ca-app-pub-5627324410826009~5563575952" : "ca-app-pub-5627324410826009/1948582817";
  // final String nativeAdUnit = Platform.isAndroid ? "ca-app-pub-5627324410826009~5563575952" : "ca-app-pub-5627324410826009/3205005920";

  final String bannerAdUnit = "ca-app-pub-3940256099942544/2435281174";
  final String interstitialAdUnit = "ca-app-pub-3940256099942544/4411468910";
  final String nativeAdUnit = "ca-app-pub-3940256099942544/3986624511";


  // -------------------------------
  // BANNER AD
  // -------------------------------
  BannerAd? bannerAd;

  Future<void> loadBanner() async {
    bannerAd = BannerAd(
      adUnitId: bannerAdUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print("Banner Loaded"),
        onAdFailedToLoad: (ad, err) {
          print("Banner Load Failed: ${err.message}");
          ad.dispose();
        },
      ),
    );

    await bannerAd!.load();
  }

  void disposeBanner() {
    bannerAd?.dispose();
  }

  // -------------------------------
  // INTERSTITIAL AD
  // -------------------------------
  InterstitialAd? _interstitialAd;

  Future<void> loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("Interstitial Loaded");
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (err) {
          print("Interstitial Failed: ${err.message}");
        },
      ),
    );
  }

  void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("Interstitial not ready");
      loadInterstitial();
    }
  }


  // -------------------------------
  // NATIVE AD
  // -------------------------------
  static NativeAd? nativeAd;
  static RxBool isNativeAdLoaded = false.obs;
  static NativeAd? nativeBannerAd;
  static RxBool isNativeBannerAdLoaded = false.obs;

  static void loadNativeAd() {
    nativeAd = NativeAd(
      // adUnitId: Platform.isAndroid ? "ca-app-pub-5627324410826009~5563575952" : "ca-app-pub-5627324410826009/3205005920",
      adUnitId: "ca-app-pub-3940256099942544/3986624511",
      factoryId: "factoryId",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print("Native Ad Loaded");
          isNativeAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          print("Native Ad Failed: $error");
          isNativeAdLoaded.value = false;
          // ad.dispose();

          // Retry
          // loadNativeAd();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium, // small/medium
      ),
    );
    nativeAd!.load();
  }

  static void loadNativeBannerAd() {
    nativeBannerAd = NativeAd(
      // adUnitId: Platform.isAndroid ? "ca-app-pub-5627324410826009~5563575952" : "ca-app-pub-5627324410826009/3205005920",
      adUnitId: "ca-app-pub-3940256099942544/3986624511",
      factoryId: "factoryId",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print("Native Ad Loaded");
          isNativeBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          print("Native Ad Failed: $error");
          isNativeBannerAdLoaded.value = false;
          // ad.dispose();

          // Retry
          // loadNativeBannerAd();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small, // small/medium
      ),
    );
    nativeBannerAd!.load();
  }

  static void disposeNativeAd() {
    nativeAd?.dispose();
    nativeAd = null;
    isNativeAdLoaded.value = false;
  }

  static void disposeNativeBannerAd() {
    isNativeBannerAdLoaded.value = false;
    nativeBannerAd?.dispose();
    nativeBannerAd = null;
  }


}

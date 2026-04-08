import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_colors.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final String bannerAdUnit = "ca-app-pub-5627324410826009/5829023311";
  final String nativeAdUnit = "ca-app-pub-5627324410826009/1395683235";

  final RxMap<String, bool> _bannerLoaded = <String, bool>{}.obs;
  final RxMap<String, bool> _bannerLoading = <String, bool>{}.obs;
  final Map<String, BannerAd> _bannerAds = {};

  final RxMap<String, bool> _nativeLoaded = <String, bool>{}.obs;
  final RxMap<String, bool> _nativeLoading = <String, bool>{}.obs;
  final Map<String, NativeAd> _nativeAds = {};

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  bool isBannerLoaded(String key) => _bannerLoaded[key] ?? false;
  bool isBannerLoading(String key) => _bannerLoading[key] ?? false;
  BannerAd? bannerFor(String key) => _bannerAds[key];

  bool isNativeLoaded(String key) => _nativeLoaded[key] ?? false;
  bool isNativeLoading(String key) => _nativeLoading[key] ?? false;
  NativeAd? nativeFor(String key) => _nativeAds[key];

  Future<void> loadBanner(
    String key, {
    AdSize size = AdSize.banner,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && (isBannerLoaded(key) || isBannerLoading(key))) {
      return;
    }

    _bannerLoading[key] = true;
    _bannerLoaded[key] = false;
    _bannerAds.remove(key)?.dispose();

    final banner = BannerAd(
      adUnitId: bannerAdUnit,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Banner Loaded: $key");
          _bannerAds[key] = ad as BannerAd;
          _bannerLoading[key] = false;
          _bannerLoaded[key] = true;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint("Banner Load Failed [$key]: ${err.message}");
          _bannerLoading[key] = false;
          _bannerLoaded[key] = false;
          ad.dispose();
        },
      ),
    );

    _bannerAds[key] = banner;
    await banner.load();
  }

  void disposeBanner(String key) {
    _bannerLoaded[key] = false;
    _bannerLoading[key] = false;
    _bannerAds.remove(key)?.dispose();
  }

  Future<void> loadNative(
    String key, {
    TemplateType templateType = TemplateType.medium,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && (isNativeLoaded(key) || isNativeLoading(key))) {
      return;
    }

    _nativeLoading[key] = true;
    _nativeLoaded[key] = false;
    _nativeAds.remove(key)?.dispose();

    final native = NativeAd(
      adUnitId: nativeAdUnit,
      factoryId: "factoryId",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint("Native Ad Loaded: $key");
          _nativeAds[key] = ad as NativeAd;
          _nativeLoading[key] = false;
          _nativeLoaded[key] = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Native Ad Failed [$key]: $error");
          _nativeLoading[key] = false;
          _nativeLoaded[key] = false;
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: templateType,
        mainBackgroundColor: AppColors.darkSurfaceStrong,
        cornerRadius: 18,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.darkPrimaryBg,
          backgroundColor: AppColors.secondary,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.darkTextPrimary,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.darkTextSecondary,
          size: 13,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.secondary,
          size: 12,
        ),
      ),
    );

    _nativeAds[key] = native;
    await native.load();
  }

  void disposeNative(String key) {
    _nativeLoading[key] = false;
    _nativeLoaded[key] = false;
    _nativeAds.remove(key)?.dispose();
  }
}

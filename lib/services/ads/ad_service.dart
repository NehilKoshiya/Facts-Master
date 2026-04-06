import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final String bannerAdUnit = "ca-app-pub-5627324410826009/5829023311";
  final String interstitialAdUnit = "ca-app-pub-5627324410826009/1339842914";
  final String nativeAdUnit = "ca-app-pub-5627324410826009/1395683235";

  final RxMap<String, bool> _bannerLoaded = <String, bool>{}.obs;
  final RxMap<String, bool> _bannerLoading = <String, bool>{}.obs;
  final Map<String, BannerAd> _bannerAds = {};

  final RxMap<String, bool> _nativeLoaded = <String, bool>{}.obs;
  final RxMap<String, bool> _nativeLoading = <String, bool>{}.obs;
  final Map<String, NativeAd> _nativeAds = {};

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _showInterstitialOnLoad = false;

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
      nativeTemplateStyle: NativeTemplateStyle(templateType: templateType),
    );

    _nativeAds[key] = native;
    await native.load();
  }

  void disposeNative(String key) {
    _nativeLoading[key] = false;
    _nativeLoaded[key] = false;
    _nativeAds.remove(key)?.dispose();
  }

  Future<void> preloadInterstitial() async {
    if (_interstitialAd != null || _isInterstitialLoading) return;

    _isInterstitialLoading = true;
    await InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("Interstitial Loaded");
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialAd!.setImmersiveMode(true);
          _attachInterstitialCallbacks(ad);
          if (_showInterstitialOnLoad) {
            _showInterstitialOnLoad = false;
            showInterstitial();
          }
        },
        onAdFailedToLoad: (err) {
          debugPrint("Interstitial Failed: ${err.message}");
          _interstitialAd = null;
          _isInterstitialLoading = false;
          _showInterstitialOnLoad = false;
        },
      ),
    );
  }

  void _attachInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("Interstitial show failed: $error");
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
      },
    );
  }

  void showInterstitial() {
    if (_interstitialAd != null) {
      final ad = _interstitialAd!;
      _interstitialAd = null;
      ad.show();
      return;
    }

    preloadInterstitial();
  }

  void showInterstitialIfReadyOrLoad() {
    if (_interstitialAd != null) {
      showInterstitial();
      return;
    }

    _showInterstitialOnLoad = true;
    preloadInterstitial();
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:daily_facts/services/ads/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/fact_model.dart';
import '../../../data/models/theme_model.dart';
import '../../../services/storage_service.dart';

class FactController extends GetxController {
  RxList<String> randomFacts = <String>[].obs;
  RxList<FactModel> categories = <FactModel>[].obs;
  RxList<FactModel> filteredCategories = <FactModel>[].obs;
  RxString selectedCategoryName = ''.obs;
  RxList<String> categoryFacts = <String>[].obs;
  RxList<String> filteredCategoryFacts = <String>[].obs;
  Rx<AppThemeModel?> currentTheme = Rx<AppThemeModel?>(null);

  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;
  RxInt showAd = 0.obs;

  final List<AppThemeModel> themeImages = [
    AppThemeModel(
      image: '',
      textColor: Colors.black,
    ),
    AppThemeModel(
      image: 'assets/images/theme1.jpg',
      textColor: Colors.black,
    ),
    AppThemeModel(
      image: 'assets/images/theme2.jpg',
      textColor: Colors.white,
    ),
    AppThemeModel(
      image: 'assets/images/theme3.jpg',
      textColor: Colors.black,
    ),
    AppThemeModel(
      image: 'assets/images/theme4.jpg',
      textColor: Colors.white,
    ),
    AppThemeModel(
      image: 'assets/images/theme5.jpg',
      textColor: Colors.black,
    ),
  ];


  @override
  void onInit() {
    loadFacts();
    loadTheme();
    AdService().loadBanner();
    super.onInit();
  }

  void selectTheme(AppThemeModel theme) {
    currentTheme.value = theme;
    StorageService().write(Constants.imagePath, theme.toJson());
  }

  void loadTheme() {
    final data = StorageService().read(Constants.imagePath);
    if (data != null) {
      currentTheme.value = AppThemeModel.fromJson(
        Map<String, dynamic>.from(data),
      );
      update();
    }
  }

  Future<void> loadFacts() async {
    final jsonString = await rootBundle.loadString('assets/json/facts.json');
    final jsonData = json.decode(jsonString);

    categories.value = (jsonData['data'] as List)
        .map((e) => FactModel.fromJson(e))
        .toList();

    filteredCategories.assignAll(categories);


    List<String> allFacts = [];
    for (var category in categories) {
      allFacts.addAll(category.facts);
    }

    allFacts.shuffle(Random());
    randomFacts.assignAll(allFacts);
  }


  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
      filteredCategories.assignAll(categories);
    }
  }

  void searchCategory(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where(
              (c) => c.categoryName.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void openCategory(FactModel category) {
    selectedCategoryName.value = category.categoryName;
    categoryFacts.assignAll(category.facts);
    filteredCategoryFacts.assignAll(category.facts);

  }

  adCount(){
    showAd.value++;
    if(showAd.value == 3) {
      showAd.value = 0;
      AdService().loadInterstitial();
      AdService().showInterstitial();
    }
  }

  void searchCategoryFacts(String query) {
    if (query.isEmpty) {
      filteredCategoryFacts.assignAll(categoryFacts);
    } else {
      filteredCategoryFacts.assignAll(
        categoryFacts.where(
              (f) => f.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

}

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/fact_model.dart';
import '../../../data/models/theme_model.dart';
import '../../../services/storage_service.dart';
import '../../../services/ads/ad_service.dart';

class FactController extends GetxController {
  Rxn<FactModel> factData = Rxn<FactModel>();
  RxList<CategoryList> allCategories = <CategoryList>[].obs;
  RxList<CategoryList> filteredCategories = <CategoryList>[].obs;

  RxList<String> randomFacts = <String>[].obs;
  RxString selectedCategoryName = ''.obs;
  RxList<String> categoryFacts = <String>[].obs;
  RxList<String> filteredCategoryFacts = <String>[].obs;

  Rx<AppThemeModel?> currentTheme = Rx<AppThemeModel?>(null);
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;
  RxInt showAd = 0.obs;

  final List<AppThemeModel> themeImages = [
    AppThemeModel(image: '', textColor: Colors.black),
    AppThemeModel(image: 'assets/images/theme1.jpg', textColor: Colors.black),
    AppThemeModel(image: 'assets/images/theme2.jpg', textColor: Colors.white),
    AppThemeModel(image: 'assets/images/theme3.jpg', textColor: Colors.black),
    AppThemeModel(image: 'assets/images/theme4.jpg', textColor: Colors.white),
    AppThemeModel(image: 'assets/images/theme5.jpg', textColor: Colors.black),
  ];

  @override
  void onInit() {
    loadFacts();
    loadTheme();
    AdService().loadBanner();
    super.onInit();
  }

  // --- Theme Methods ---
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

  // --- Data Loading ---
  Future<void> loadFacts() async {
    // try {
    print("Loading JSON..."); // Debug Point
    final jsonString = await rootBundle.loadString('assets/json/facts.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    print("JSON Decoded successfully"); // Debug Point

    final model = FactModel.fromJson(jsonData);

    print('modelmodel ::${model.data.length}');
    factData.value = model;

    List<CategoryList> tempAllCategories = [];
    List<String> tempAllFacts = [];

    if (model.data.isNotEmpty) {
      for (var datum in model.data) {
        print('modelmodel ::${datum.categoryTitleName}');

        for (var category in datum.categoryList) {
          tempAllCategories.add(category);
          tempAllFacts.addAll(category.facts);
        }
      }

      allCategories.assignAll(tempAllCategories);
      filteredCategories.assignAll(tempAllCategories);

      tempAllFacts.shuffle(Random());
      randomFacts.assignAll(tempAllFacts);

      print("Facts Loaded: ${randomFacts.length}"); // Debug Point
    } else {
      print("Data is empty in JSON");
    }
    // } catch (e) {
    //   print("Error loading facts: $e"); // અહીં તમને ચોક્કસ Error દેખાશે
    // }
  }

  // --- Search & Selection ---
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
      filteredCategories.assignAll(allCategories);
    }
  }

  void searchCategory(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      filteredCategories.assignAll(
        allCategories
            .where(
              (c) => c.categoryName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void openCategory(CategoryList category) {
    selectedCategoryName.value = category.categoryName;
    categoryFacts.assignAll(category.facts);
    filteredCategoryFacts.assignAll(category.facts);
  }

  void searchCategoryFacts(String query) {
    if (query.isEmpty) {
      filteredCategoryFacts.assignAll(categoryFacts);
    } else {
      filteredCategoryFacts.assignAll(
        categoryFacts
            .where((f) => f.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  // --- Ads ---
  void adCount() {
    showAd.value++;
    if (showAd.value >= 3) {
      showAd.value = 0;
      AdService().loadInterstitial();
      AdService().showInterstitial();
    }
  }
}

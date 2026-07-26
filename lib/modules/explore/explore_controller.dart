import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/data/repo/recipe_repository.dart';

import '../../../data/models/recipe_model.dart';

class ExploreController extends GetxController {
  final RecipeRepository repository = RecipeRepository();

  /// All recipes
  final allRecipes = <RecipeModel>[].obs;

  /// Recipes displayed in UI
  final recipes = <RecipeModel>[].obs;

  final isLoading = false.obs;

  final searchController = TextEditingController();
  final search = ''.obs;

  Worker? debounceWorker;

  final cuisines = <String>[].obs;
  final selectedCuisine = 'All'.obs;

  @override
  void onInit() {
    super.onInit();

    loadRecipes();

    debounceWorker = debounce(
      search,
      (_) => applyFilters(),
      time: const Duration(milliseconds: 400),
    );
  }

  Future<void> loadRecipes() async {
    isLoading.value = true;

    try {
      final result = await repository.fetchRecipes(
        limit: 0,
        skip: 0,
      );

      allRecipes.assignAll(result);

      generateCuisineList();

      applyFilters();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void generateCuisineList() {
    final cuisineSet = <String>{};

    for (final recipe in allRecipes) {
      if (recipe.cuisine.isNotEmpty) {
        cuisineSet.add(recipe.cuisine);
      }
    }

    final sorted = cuisineSet.toList()..sort();

    cuisines.assignAll([
      'All',
      ...sorted,
    ]);
  }

  void applyFilters() {
    List<RecipeModel> filtered = List.from(allRecipes);

    if (search.value.trim().isNotEmpty) {
      filtered = filtered.where((recipe) {
        return recipe.name
            .toLowerCase()
            .contains(search.value.toLowerCase());
      }).toList();
    }

    if (selectedCuisine.value != 'All') {
      filtered = filtered.where((recipe) {
        return recipe.cuisine == selectedCuisine.value;
      }).toList();
    }

    recipes.assignAll(filtered);
  }

  Future<void> refreshRecipes() async {
    searchController.clear();
    search.value = "";
    selectedCuisine.value = "All";

    await loadRecipes();
  }

  void changeCuisine(String cuisine) {
    selectedCuisine.value = cuisine;
    applyFilters();
  }

  @override
  void onClose() {
    debounceWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }
}
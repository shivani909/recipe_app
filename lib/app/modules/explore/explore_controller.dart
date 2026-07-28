import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/data/models/recipe_model.dart';
import 'package:recipe_app/app/data/repositories/recipe_repository.dart';

class ExploreController extends GetxController {
  final RecipeRepository repository = RecipeRepository();

  /// All recipes fetched so far
  final allLoadedRecipes = <RecipeModel>[].obs;

  /// Recipes displayed in UI
  final recipes = <RecipeModel>[].obs;

  /// Cuisine chips
  final cuisines = <String>[].obs;

  final selectedCuisine = "All".obs;

  /// Loading
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  /// Search
  final searchController = TextEditingController();
  final search = "".obs;

  /// Scroll
  final scrollController = ScrollController();

  Worker? debounceWorker;

  static const int _pageSize = 10;

  int _skip = 0;

  /// Total recipes available on the server for the current query
  /// (resets on refresh, comes from the API response - not guessed).
  int _total = 0;

  bool get hasMore => _skip < _total;

  @override
  void onInit() {
    super.onInit();

    loadRecipes(refresh: true);

    scrollController.addListener(_onScroll);

    debounceWorker = debounce(
      search,
      (_) => loadRecipes(refresh: true),
      time: const Duration(milliseconds: 500),
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadRecipes();
    }
  }

  Future<void> loadRecipes({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _total = 0;

      recipes.clear();
      allLoadedRecipes.clear();
      cuisines.clear();
    }

    if (!refresh && !hasMore) return;

    await _fetchPage();

    // If a cuisine filter is active, the freshly fetched page might not
    // contain any matches, leaving the visible `recipes` list too short
    // to trigger further scroll-based pagination. Keep fetching until
    // there's enough to fill the screen or there's nothing left.
    await _ensureEnoughFilteredResults();
  }

  /// Fetches exactly one page (limit/skip) and merges it into state.
  Future<void> _fetchPage() async {
    if (isLoading.value || isLoadingMore.value) return;

    if (_skip == 0) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await repository.fetchRecipes(
        limit: _pageSize,
        skip: _skip,
        search: search.value,
      );

      allLoadedRecipes.addAll(result.recipes);
      _total = result.total;
      _skip += result.recipes.length;

      // Defensive: if the server ever returns an empty page before our
      // skip has caught up with total (bad data, race, etc.), stop.
      if (result.recipes.isEmpty) {
        _total = _skip;
      }

      _generateCuisineList();
      applyFilters();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> _ensureEnoughFilteredResults() async {
    while (selectedCuisine.value != "All" &&
        recipes.length < _pageSize &&
        hasMore) {
      await _fetchPage();
    }
  }

  void _generateCuisineList() {
    final set = <String>{};

    for (final recipe in allLoadedRecipes) {
      if (recipe.cuisine.isNotEmpty) {
        set.add(recipe.cuisine);
      }
    }

    final sorted = set.toList()..sort();

    cuisines.assignAll([
      "All",
      ...sorted,
    ]);
  }

  void applyFilters() {
    List<RecipeModel> filtered = List.from(allLoadedRecipes);

    if (selectedCuisine.value != "All") {
      filtered = filtered
          .where((recipe) => recipe.cuisine == selectedCuisine.value)
          .toList();
    }

    recipes.assignAll(filtered);
  }

  void changeCuisine(String cuisine) {
    if (selectedCuisine.value == cuisine) return;

    selectedCuisine.value = cuisine;

    applyFilters();
    _ensureEnoughFilteredResults();
  }

  Future<void> refreshRecipes() async {
    searchController.clear();
    search.value = "";
    selectedCuisine.value = "All";

    await loadRecipes(refresh: true);
  }

  @override
  void onClose() {
    debounceWorker?.dispose();
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
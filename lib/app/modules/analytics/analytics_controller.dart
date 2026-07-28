import 'package:get/get.dart';
import '../../data/models/recipe_model.dart';

class AnalyticsController extends GetxController {
  final cuisineCount = <String, int>{}.obs;
  final difficultyCount = <String, int>{}.obs;
  final RxMap<String, int> cuisineViews = <String, int>{}.obs;
  final totalRecipes = 0.obs;
  final totalCuisines = 0.obs;
  final averageRating = 0.0.obs;
  final averagePrepTime = 0.0.obs;

  final topRecipes = <RecipeModel>[].obs;


    void recordRecipeView(String cuisine) {
    cuisineViews[cuisine] =
        (cuisineViews[cuisine] ?? 0) + 1;
  }

  void generateAnalytics(List<RecipeModel> recipes) {
    cuisineCount.clear();
    difficultyCount.clear();

    totalRecipes.value = recipes.length;

    double ratingSum = 0;
    double prepTime = 0;

    for (final recipe in recipes) {
      cuisineCount.update(
        recipe.cuisine,
        (v) => v + 1,
        ifAbsent: () => 1,
      );

      difficultyCount.update(
        recipe.difficulty,
        (v) => v + 1,
        ifAbsent: () => 1,
      );

      ratingSum += recipe.rating;
      prepTime += recipe.prepTimeMinutes;
    }

    totalCuisines.value = cuisineCount.length;

    averageRating.value =
        recipes.isEmpty ? 0 : ratingSum / recipes.length;

    averagePrepTime.value =
        recipes.isEmpty ? 0 : prepTime / recipes.length;

    final sorted = [...recipes];

    sorted.sort((a, b) => b.rating.compareTo(a.rating));

    topRecipes.assignAll(
      sorted.take(5).toList(),
    );
  }
}
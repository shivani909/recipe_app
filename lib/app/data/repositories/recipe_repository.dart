import '../../core/api/api_client.dart';
import '../models/recipe_model.dart';

class RecipeListResult {
  final List<RecipeModel> recipes;
  final int total;
  final int skip;
  final int limit;

  RecipeListResult({
    required this.recipes,
    required this.total,
    required this.skip,
    required this.limit,
  });
}

class RecipeRepository {

  Future<RecipeListResult> fetchRecipes({
    required int limit,
    required int skip,
    String search = "",
  }) async {
    final endpoint = search.isEmpty ? "recipes" : "recipes/search";

    final response = await ApiClient.dio.get(
      endpoint,
      queryParameters: {
        "limit": limit,
        "skip": skip,
        if (search.isNotEmpty) "q": search,
      },
    );

    final List recipesJson = response.data["recipes"] ?? [];
    final int total = response.data["total"] ?? recipesJson.length;
    final int respSkip = response.data["skip"] ?? skip;
    final int respLimit = response.data["limit"] ?? limit;

    return RecipeListResult(
      recipes: recipesJson.map((e) => RecipeModel.fromJson(e)).toList(),
      total: total,
      skip: respSkip,
      limit: respLimit,
    );
  }
}
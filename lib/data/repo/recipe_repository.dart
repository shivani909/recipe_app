import '../../core/api/api_client.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  /// Fetch paginated recipes
  Future<List<RecipeModel>> fetchRecipes({
    required int limit,
    required int skip,
    String search = "",
    String cuisine = "All",
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

    List recipes = response.data["recipes"] as List;

    // DummyJSON doesn't support cuisine filtering on the server,
    // so we filter the current page locally.
    if (cuisine != "All") {
      recipes = recipes
          .where((recipe) => recipe["cuisine"] == cuisine)
          .toList();
    }

    return recipes
        .map((json) => RecipeModel.fromJson(json))
        .toList();
  }
}
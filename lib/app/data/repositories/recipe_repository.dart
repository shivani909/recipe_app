import '../../core/api/api_client.dart';
import '../models/recipe_model.dart';

/// Wraps a page of recipes together with the pagination metadata DummyJSON
/// returns (total, skip, limit). Returning `total` (not just the list) is
/// what lets the controller know for certain when there's no more data,
/// instead of guessing from `result.length < pageSize`.
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
  /// Fetch paginated recipes using limit & skip.
  /// Uses /recipes for browsing, /recipes/search when a query is present.
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
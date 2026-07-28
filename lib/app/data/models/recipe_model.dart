class RecipeModel {
  final int id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final String difficulty;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      cuisine: json["cuisine"],
      rating: (json["rating"] as num).toDouble(),
      difficulty: json["difficulty"],
      prepTimeMinutes: json["prepTimeMinutes"],
      cookTimeMinutes: json["cookTimeMinutes"],
      ingredients: List<String>.from(json["ingredients"]),
      instructions: List<String>.from(json["instructions"]),
    );
  }
  Map<String, dynamic> toJson() {
  return {
    "id": id,
    "name": name,
    "image": image,
    "cuisine": cuisine,
    "rating": rating,
    "difficulty": difficulty,
    "prepTimeMinutes": prepTimeMinutes,
    "cookTimeMinutes": cookTimeMinutes,
    "ingredients": ingredients,
    "instructions": instructions,
  };
}

factory RecipeModel.fromStorage(Map<String, dynamic> json) {
  return RecipeModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    cuisine: json["cuisine"],
    rating: (json["rating"] as num).toDouble(),
    difficulty: json["difficulty"],
    prepTimeMinutes: json["prepTimeMinutes"],
    cookTimeMinutes: json["cookTimeMinutes"],
    ingredients: List<String>.from(json["ingredients"]),
    instructions: List<String>.from(json["instructions"]),
  );
}
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/app/modules/analytics/analytics_controller.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_controller.dart';

import '../../../data/models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  RecipeCard({super.key, required this.recipe});
  final WishlistController wishlistController = Get.find<WishlistController>();
  final analyticsController = Get.find<AnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        analyticsController.recordRecipeView(recipe.cuisine);
        Get.toNamed(Routes.recipe, arguments: recipe);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "recipe_${recipe.id}",
                  child: CachedNetworkImage(
                    imageUrl: recipe.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(height: 220, color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Obx(() {
                    final isFavorite = wishlistController.isFavourite(
                      recipe.id,
                    );

                    return CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          wishlistController.toggleWishlist(recipe);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(recipe.cuisine),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),

                      const SizedBox(width: 5),

                      Text(recipe.rating.toString()),

                      const Spacer(),

                      Chip(label: Text(recipe.difficulty)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

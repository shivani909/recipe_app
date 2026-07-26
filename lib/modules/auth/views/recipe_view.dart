import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/modules/explore/recipe_controller.dart';
import 'package:recipe_app/modules/wishlist/controllers/wishlist_controller.dart';

class RecipeView extends GetView<RecipeController> {
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = controller.recipe;
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,

            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(recipe.name),

              background: Hero(
                tag: "recipe_${recipe.id}",
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),

                      const SizedBox(width: 5),

                      Text(recipe.rating.toString()),

                      const Spacer(),

                      Chip(label: Text(recipe.difficulty)),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.restaurant, size: 18),
                        label: Text(recipe.cuisine),
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer, size: 18),
                        label: Text("${recipe.prepTimeMinutes} min Prep"),
                      ),
                      Chip(
                        avatar: const Icon(
                          Icons.local_fire_department,
                          size: 18,
                        ),
                        label: Text("${recipe.cookTimeMinutes} min Cook"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(Icons.timer),

                      const SizedBox(width: 10),

                      Text("${recipe.prepTimeMinutes} min"),

                      const SizedBox(width: 20),

                      Text("${recipe.cookTimeMinutes} min"),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Servings",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => Row(
                      children: [
                        IconButton(
                          onPressed: controller.decreaseServing,

                          icon: const Icon(Icons.remove),
                        ),

                        Text(
                          controller.servings.value.toString(),

                          style: const TextStyle(fontSize: 22),
                        ),

                        IconButton(
                          onPressed: controller.increaseServing,

                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Ingredients",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.ingredients.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),

                      child: Card(
                        elevation: 0,
                        color: Colors.green.shade50,
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: Text(e),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Instructions",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.instructions.asMap().entries.map((step) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text("${step.key + 1}")),
                        title: Text(step.value),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: Obx(() {
                      final isFav = wishlist.isFavourite(recipe.id);

                      return ElevatedButton.icon(
                        onPressed: () {
                          wishlist.toggleWishlist(recipe);
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          isFav ? "Remove from Wishlist" : "Add to Wishlist",
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.map);
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text("Buy Ingredients Nearby"),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

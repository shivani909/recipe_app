import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/core/widgets/empty_state_widget.dart';
import 'package:recipe_app/modules/auth/views/recipe_view.dart';
import 'package:recipe_app/modules/wishlist/controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.favorite_border,
            title: "Your Wishlist is Empty",
            subtitle: "Save recipes and they'll appear here.",
          );
        }

        return ListView.builder(
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final recipe = controller.wishlist[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(recipe.image),
              ),
              title: Text(recipe.name),
              subtitle: Text(recipe.cuisine),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.toggleWishlist(recipe);
                },
              ),
              onTap: () {
                Get.toNamed(Routes.recipe, arguments: recipe);
              },
            );
          },
        );
      }),
    );
  }
}

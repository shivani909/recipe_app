import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/theme/app_colors.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/app/core/widgets/empty_state_widget.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.favorite_border,
            title: "Your Wishlist is Empty",
            subtitle: "Save recipes and they'll appear here.",
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${controller.wishlist.length} saved ${controller.wishlist.length == 1 ? 'recipe' : 'recipes'}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: controller.wishlist.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final recipe = controller.wishlist[index];

                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 1.5,
                    shadowColor: Colors.black.withOpacity(.08),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Get.toNamed(Routes.recipe, arguments: recipe);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.cardBackground,
                                backgroundImage: NetworkImage(recipe.image),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    recipe.cuisine,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                        
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => controller.toggleWishlist(recipe),
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

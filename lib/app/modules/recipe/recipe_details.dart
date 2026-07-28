import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/theme/app_colors.dart';
import 'package:recipe_app/app/routes/app_routes.dart';
import 'package:recipe_app/app/modules/recipe/recipe_controller.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_controller.dart';

class RecipeDetails extends GetView<RecipeController> {
  const RecipeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = controller.recipe;
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            // Circular backing on the back button so it stays visible
            // over both light and dark parts of the photo.
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(.35),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 14,
              ),
              title: Text(
                recipe.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Hero(
                tag: "recipe_${recipe.id}",
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                    ),
                    // Stronger, taller gradient so the title is always
                    // legible regardless of what's in the photo.
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 1],
                          colors: [Colors.transparent, Colors.black87],
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
                      const Icon(Icons.star_rounded, color: AppColors.accent),
                      const SizedBox(width: 5),
                      Text(
                        recipe.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      _InfoChip(
                        icon: Icons.bar_chart_rounded,
                        label: recipe.difficulty,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // All meta info consolidated into one consistent chip
                  // style — the "Easy" chip above and these used to look
                  // like two different components.
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoChip(icon: Icons.restaurant, label: recipe.cuisine),
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: "${recipe.prepTimeMinutes} min Prep",
                      ),
                      _InfoChip(
                        icon: Icons.local_fire_department_outlined,
                        label: "${recipe.cookTimeMinutes} min Cook",
                      ),
                    ],
                  ),

                  // The old plain "20 min   15 min" row repeated the same
                  // prep/cook numbers already shown in the chips above,
                  // without even labeling which was which — removed.
                  const SizedBox(height: 28),

                  const Text(
                    "Servings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(
                    () => Row(
                      children: [
                        _ServingButton(
                          icon: Icons.remove,
                          onTap: controller.decreaseServing,
                        ),
                        SizedBox(
                          width: 52,
                          child: Text(
                            controller.servings.value.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _ServingButton(
                          icon: Icons.add,
                          onTap: controller.increaseServing,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.ingredients.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          leading: const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                          ),
                          title: Text(
                            e,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.instructions.asMap().entries.map((step) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          // Solid primary circle with white text reads far
                          // better than the previous light-on-light number.
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              "${step.key + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            step.value,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  // Wishlist toggle — outlined by default, fills solid
                  // once favorited so the state change is obvious at a
                  // glance (not just an icon swap).
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(() {
                      final isFav = wishlist.isFavourite(recipe.id);

                      return isFav
                          ? ElevatedButton.icon(
                              onPressed: () => wishlist.toggleWishlist(recipe),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.favorite, size: 20),
                              label: const Text(
                                "Remove from Wishlist",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            )
                          : OutlinedButton.icon(
                              onPressed: () => wishlist.toggleWishlist(recipe),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: AppColors.border,
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.favorite_border, size: 20),
                              label: const Text(
                                "Add to Wishlist",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            );
                    }),
                  ),

                  const SizedBox(height: 12),

                  // Primary conversion action for this screen — filled
                  // solid so it clearly outranks the wishlist toggle.
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.map),
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text(
                        "Buy Ingredients Nearby",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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

/// Consistent chip used for difficulty, cuisine, prep time, cook time —
/// previously "Easy" used a stock Chip while the others below used a
/// different Chip configuration, so they didn't visually match.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular +/- button with a visible outline and background — the old
/// plain IconButton had no shape at all, so it read as decoration rather
/// than a tappable control.
class _ServingButton extends StatelessWidget {
  const _ServingButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}

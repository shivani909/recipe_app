import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/widgets/empty_state_widget.dart';
import 'package:recipe_app/modules/explore/explore_controller.dart';
import 'package:recipe_app/modules/explore/widgets/recipe_card.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Explorer")),
      body: RefreshIndicator(
        onRefresh: controller.refreshRecipes,
        child: Obx(
          () => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              /// Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search recipes...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      controller.search.value = value;
                    },
                  ),
                ),
              ),

              /// Cuisine Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.cuisines.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cuisine = controller.cuisines[index];

                      return Obx(
                        () => ChoiceChip(
                          label: Text(cuisine),
                          selected: controller.selectedCuisine.value == cuisine,
                          onSelected: (_) {
                            controller.changeCuisine(cuisine);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              /// Initial Loading
              if (controller.isLoading.value)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              /// Empty State
              else if (controller.recipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    icon: Icons.restaurant_menu,
                    title: "No Recipes Found",
                    subtitle:
                        "Try another search or change the cuisine filter.",
                    buttonText: "Clear Filters",
                    onPressed: controller.refreshRecipes,
                  ),
                )
              /// Recipe List
              else ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return RecipeCard(recipe: controller.recipes[index]);
                  }, childCount: controller.recipes.length),
                ),

                /// Loading More

                /// End of List
              ],
            ],
          ),
        ),
      ),
    );
  }
}

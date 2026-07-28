import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/theme/app_colors.dart';
import 'package:recipe_app/app/core/widgets/empty_state_widget.dart';
import 'package:recipe_app/app/modules/analytics/analytics_controller.dart';
import 'package:recipe_app/app/modules/explore/explore_controller.dart';
import 'package:recipe_app/app/modules/recipe/widgets/recipe_card.dart';

class ExploreView extends GetView<ExploreController> {
  ExploreView({super.key});

  final AnalyticsController analyticsController =
      Get.find<AnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Recipe Explorer",
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
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refreshRecipes,
        child: Obx(
          () => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              /// Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: controller.searchController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: "Search recipes...",
                      hintStyle: TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.6,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      controller.search.value = value;
                    },
                  ),
                ),
              ),

            
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

                      return Obx(() {
                        final isSelected =
                            controller.selectedCuisine.value == cuisine;

                        return ChoiceChip(
                          label: Text(cuisine),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.changeCuisine(cuisine);
                          },
                          showCheckmark: false,
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

             
              if (controller.isLoading.value)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
             
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
              
              else ...[
               
                SliverToBoxAdapter(
                  child: Obx(() {
                    final entries = analyticsController.cuisineViews.entries
                        .toList();

                    if (entries.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final maxValue = entries
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b);

                    final totalViews = entries.fold(
                      0,
                      (sum, e) => sum + e.value,
                    );

                    final topCuisine = entries.reduce(
                      (a, b) => a.value >= b.value ? a : b,
                    );

                    return Card(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.analytics_rounded,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Top Recipes",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.statChipBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Total Views",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$totalViews",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.statChipBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Top Cuisine",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          topCuisine.key,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                           
                            Builder(
                              builder: (context) {
                               
                                final interval = maxValue <= 6
                                    ? 1
                                    : maxValue <= 12
                                    ? 2
                                    : 5;
                                final chartMaxY =
                                    (((maxValue / interval).ceil() + 1) *
                                            interval)
                                        .toDouble();

                                final topIndex = entries.indexWhere(
                                  (e) => e.key == topCuisine.key,
                                );

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: BarChart(
                                        BarChartData(
                                          minY: 0,
                                          maxY: chartMaxY,

                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          groupsSpace: 18,

                                          borderData: FlBorderData(show: false),

                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            horizontalInterval: interval
                                                .toDouble(),
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                color: AppColors.chartGridLine,
                                                strokeWidth: 1,
                                              );
                                            },
                                          ),

                                          barTouchData: BarTouchData(
                                            enabled: true,
                                            touchTooltipData: BarTouchTooltipData(
                                              tooltipBorderRadius:
                                                  BorderRadius.circular(10),
                                              tooltipPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              tooltipMargin: 10,
                                              getTooltipColor: (_) =>
                                                  Colors.white,
                                              getTooltipItem:
                                                  (
                                                    group,
                                                    groupIndex,
                                                    rod,
                                                    rodIndex,
                                                  ) {
                                                    final isTop =
                                                        groupIndex == topIndex;
                                                    return BarTooltipItem(
                                                      "${entries[groupIndex].key}\n",
                                                      const TextStyle(
                                                        color: AppColors
                                                            .textSecondary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${entries[groupIndex].value} views",
                                                          style: TextStyle(
                                                            color: isTop
                                                                ? AppColors
                                                                      .accent
                                                                : AppColors
                                                                      .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                            ),
                                          ),

                                          barGroups: List.generate(entries.length, (
                                            index,
                                          ) {
                                            final isTop = index == topIndex;

                                            return BarChartGroupData(
                                              x: index,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: entries[index].value
                                                      .toDouble(),
                                                  width: 16,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: isTop
                                                        ? [
                                                            AppColors.accent,
                                                            AppColors.accent
                                                                .withOpacity(
                                                                  .75,
                                                                ),
                                                          ]
                                                        : [
                                                            AppColors.primary,
                                                            AppColors.primary
                                                                .withOpacity(
                                                                  .7,
                                                                ),
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        topRight:
                                                            Radius.circular(5),
                                                      ),
                                                  backDrawRodData:
                                                      BackgroundBarChartRodData(
                                                        show: true,
                                                        toY: chartMaxY,
                                                        color: AppColors
                                                            .chartBackgroundTrack,
                                                      ),
                                                ),
                                              ],
                                            );
                                          }),

                                          titlesData: FlTitlesData(
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),

                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),

                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                interval: interval.toDouble(),
                                                getTitlesWidget: (value, meta) {
                                                  return Text(
                                                    value.toInt().toString(),
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            bottomTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Tap a bar to see the cuisine name and views",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textHint,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                /// Recipes
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return RecipeCard(recipe: controller.recipes[index]);
                  }, childCount: controller.recipes.length),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

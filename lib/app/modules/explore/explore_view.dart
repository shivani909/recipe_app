import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(title: const Text("Recipe Explorer")),
      body: RefreshIndicator(
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

              /// Loading
              if (controller.isLoading.value)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              /// Empty
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
              /// Content
              else ...[
                /// Analytics Chart
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
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Top Recipes",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Total Views",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$totalViews",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Top Cuisine",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          topCuisine.key,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Recipes Per Cuisine bar chart.
                            // Expects `entries` (List<MapEntry<String, int>>), `maxValue` (int),
                            // and `topCuisine` (MapEntry<String, int>) to be in scope.
                            Builder(
                              builder: (context) {
                                final baseColor = Theme.of(
                                  context,
                                ).colorScheme.primary;
                                final highlightColor = const Color(
                                  0xFFE07A3F,
                                ); // warm accent for the top cuisine

                                // Pick a clean interval so the grid doesn't
                                // add awkward dead space above the tallest bar.
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
                                                color: Colors.grey.shade300,
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
                                                      TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade800,
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
                                                                ? highlightColor
                                                                : baseColor,
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

                                          // Names only appear on tap now (via the
                                          // tooltip above) — no permanent labels.
                                          barGroups: List.generate(
                                            entries.length,
                                            (index) {
                                              final isTop = index == topIndex;

                                              return BarChartGroupData(
                                                x: index,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: entries[index].value
                                                        .toDouble(),
                                                    width: 16,
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: isTop
                                                          ? [
                                                              highlightColor,
                                                              highlightColor
                                                                  .withOpacity(
                                                                    .75,
                                                                  ),
                                                            ]
                                                          : [
                                                              baseColor,
                                                              baseColor
                                                                  .withOpacity(
                                                                    .7,
                                                                  ),
                                                            ],
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                5,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                    backDrawRodData:
                                                        BackgroundBarChartRodData(
                                                          show: true,
                                                          toY: chartMaxY,
                                                          color: Colors.grey
                                                              .withOpacity(.06),
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),

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
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey.shade600,
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
                                    Text(
                                      "Tap a bar to see the cuisine name and views",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
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

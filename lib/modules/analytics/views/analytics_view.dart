import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/modules/analytics/widget/stat_card.dart';

import '../../explore/explore_controller.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final explore = Get.find<ExploreController>();

    controller.generateAnalytics(explore.allRecipes);

    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Analytics")),
      body: Obx(() {
        if (controller.totalRecipes.value == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        final cuisineEntries = controller.cuisineCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topCuisine = cuisineEntries.take(8).toList();

        final difficultyEntries = controller.difficultyCount.entries.toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Statistics
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  StatCard(
                    title: "Recipes",
                    value: controller.totalRecipes.value.toString(),
                    icon: Icons.restaurant_menu_rounded,
                    color: Colors.deepOrange,
                  ),
                  StatCard(
                    title: "Cuisines",
                    value: controller.totalCuisines.value.toString(),
                    icon: Icons.public,
                    color: Colors.blue,
                  ),
                  StatCard(
                    title: "Avg Rating",
                    value: controller.averageRating.value.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  StatCard(
                    title: "Avg Prep",
                    value: "${controller.averagePrepTime.value.toInt()} min",
                    icon: Icons.timer_outlined,
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Recipes by Cuisine",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY:
                          topCuisine
                              .map((e) => e.value)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble() +
                          1,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= topCuisine.length) {
                                return const SizedBox();
                              }

                              return SideTitleWidget(
                                meta: meta,
                                space: 8,
                                child: Transform.rotate(
                                  angle: -0.6,
                                  child: Text(
                                    topCuisine[value.toInt()].key,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        topCuisine.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: topCuisine[index].value.toDouble(),
                              width: 22,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Color(0xFF26C6DA), Color(0xFF80DEEA)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Difficulty Distribution",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: List.generate(difficultyEntries.length, (index) {
                      return PieChartSectionData(
                        value: difficultyEntries[index].value.toDouble(),
                        title: difficultyEntries[index].key,
                        radius: 90,
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Top Rated Recipes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.topRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.topRecipes[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(recipe.image),
                      ),
                      title: Text(recipe.name),
                      subtitle: Text(recipe.cuisine),
                      trailing: Text("⭐ ${recipe.rating}"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

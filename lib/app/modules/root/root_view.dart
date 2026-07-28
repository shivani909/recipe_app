import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/state_manager.dart';
import 'package:recipe_app/app/modules/analytics/analytics_controller.dart';
import 'package:recipe_app/app/modules/root/root_controller.dart';
import 'package:recipe_app/app/modules/explore/explore_view.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_view.dart';
import 'package:recipe_app/app/modules/profile/profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AnalyticsController());

    final pages = [ExploreView(), const WishlistView(), const ProfileView()];

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            //      NavigationDestination(
            //   icon: Icon(Icons.analytics_outlined),
            //   selectedIcon: Icon(Icons.analytics),
            //   label: '',
            // ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

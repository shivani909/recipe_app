import 'package:get/get.dart';
import 'package:recipe_app/modules/analytics/controllers/analytics_controller.dart';
import 'package:recipe_app/modules/explore/explore_controller.dart';
import 'package:recipe_app/modules/wishlist/controllers/wishlist_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());

    Get.lazyPut(() => ExploreController());

    Get.lazyPut(
  () => WishlistController(),
  fenix: true,
);
Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}
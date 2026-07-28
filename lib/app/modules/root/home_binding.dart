import 'package:get/get.dart';
import 'package:recipe_app/app/modules/analytics/analytics_controller.dart';
import 'package:recipe_app/app/modules/explore/explore_controller.dart';
import 'package:recipe_app/app/modules/profile/profile_controller.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_controller.dart';

import 'root_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut(() => ExploreController());

    Get.lazyPut(() => WishlistController(), fenix: true);
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}

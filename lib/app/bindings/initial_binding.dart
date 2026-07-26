import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:recipe_app/core/api/api_client.dart';
import 'package:recipe_app/data/repo/recipe_repository.dart';
import 'package:recipe_app/modules/auth/controllers/auth_controller.dart';
import 'package:recipe_app/modules/auth/controllers/home_controller.dart';
import 'package:recipe_app/modules/explore/explore_controller.dart';
import 'package:recipe_app/modules/explore/recipe_controller.dart';
import 'package:recipe_app/modules/wishlist/controllers/wishlist_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(ApiClient());

    Get.put(RecipeRepository());

    Get.put(AuthController(), permanent: true);

    Get.put(HomeController(), permanent: true);

    Get.put(ExploreController(), permanent: true);

    Get.put(WishlistController(), permanent: true);

    Get.put(RecipeController(), permanent: true);

    // Get.put(MapController(), permanent: true);

  }
}
import 'package:get/get.dart';
import 'package:recipe_app/modules/explore/recipe_controller.dart';



class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeController>(
      () => RecipeController(),
    );
  }
}
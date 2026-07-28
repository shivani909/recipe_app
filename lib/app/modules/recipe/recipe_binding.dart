import 'package:get/get.dart';
import 'package:recipe_app/app/modules/recipe/recipe_controller.dart';



class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeController>(
      () => RecipeController(),
    );
  }
}
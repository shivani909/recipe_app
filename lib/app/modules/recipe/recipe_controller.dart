import 'package:get/get.dart';

import '../../data/models/recipe_model.dart';

class RecipeController extends GetxController {

  late RecipeModel recipe;

  RxInt servings = 1.obs;

  @override
  void onInit() {

    super.onInit();

    recipe = Get.arguments;

  }

  void increaseServing() {

    servings++;

  }

  void decreaseServing() {

    if (servings > 1) {

      servings--;

    }

  }

}
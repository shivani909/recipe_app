import 'package:get/get.dart';
import 'package:recipe_app/app/modules/explore/explore_controller.dart';


class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExploreController());
  }
}
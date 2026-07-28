import 'package:get/get.dart';
import 'package:recipe_app/app/modules/wishlist/wishlist_controller.dart';



class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WishlistController(),
      fenix: true,
    );
  }
}
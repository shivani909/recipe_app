import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/storage/storage_keys.dart';
import '../../../data/models/recipe_model.dart';

class WishlistController extends GetxController {
  final box = GetStorage();

  RxList<RecipeModel> wishlist = <RecipeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() {
    final List data = box.read(StorageKeys.wishlist) ?? [];

    wishlist.assignAll(
      data
          .map(
            (e) => RecipeModel.fromStorage(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  bool isFavourite(int id) {
    return wishlist.any((e) => e.id == id);
  }

  void toggleWishlist(RecipeModel recipe) {
    if (isFavourite(recipe.id)) {
      wishlist.removeWhere((e) => e.id == recipe.id);
    } else {
      wishlist.add(recipe);
    }

    saveWishlist();
  }

  void saveWishlist() {
    box.write(
      StorageKeys.wishlist,
      wishlist.map((e) => e.toJson()).toList(),
    );
  }
}
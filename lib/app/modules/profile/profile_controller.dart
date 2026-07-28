import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:io';


import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();
  final ImagePicker _picker = ImagePicker();

  /// Logged in user
  User? get user => _auth.currentUser;

  /// Local profile image path
  final RxnString localImagePath = RxnString();

  @override
  void onInit() {
    super.onInit();

    localImagePath.value = _storage.read<String>("profile_image");
  }

  /// Pick image from gallery
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      localImagePath.value = image.path;

      await _storage.write("profile_image", image.path);

      Get.snackbar(
        "Success",
        "Profile picture updated.",
      );
    } catch (e, stackTrace) {
  debugPrint("Image Picker Error: $e");
  debugPrintStack(stackTrace: stackTrace);

  Get.snackbar(
    "Error",
    e.toString(),
  );
}
  }

  /// Returns the image file if available
  File? get profileImage {
    if (localImagePath.value == null) return null;

    final file = File(localImagePath.value!);

    return file.existsSync() ? file : null;
  }

 Future<void> logout() async {
  try {
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();

    Get.offAllNamed(Routes.login);
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}
}
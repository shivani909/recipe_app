import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/store_model.dart';
import '../repositories/map_repository.dart';

class MapController extends GetxController {
  final currentLocation = const LatLng(20.5937, 78.9629).obs;
  final currentAddress = "Fetching location...".obs;
  final isLoading = false.obs;

  final mapRepository = MapRepository();

  final stores = <StoreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> openGoogleMaps(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        "Error",
        "Could not open Google Maps",
      );
    }
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;

    try {
      // Check location service
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar(
          "Location",
          "Please enable location services.",
        );
        return;
      }

      // Check permissions
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission",
          "Location permission permanently denied.",
        );
        return;
      }

      // Current position
      final position =
          await Geolocator.getCurrentPosition();

      currentLocation.value = LatLng(
        position.latitude,
        position.longitude,
      );

      // Address
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;

        currentAddress.value =
            "${place.locality}, ${place.administrativeArea}";
      }

      // Fetch stores
      final nearbyStores =
          await mapRepository.getNearbyStores(
        position.latitude,
        position.longitude,
      );

      // Calculate distance
      for (final store in nearbyStores) {
        store.distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          store.latitude,
          store.longitude,
        );
      }

      // Sort nearest first
      nearbyStores.sort(
        (a, b) => a.distance.compareTo(b.distance),
      );

      stores.assignAll(nearbyStores);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch nearby stores.\n$e",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
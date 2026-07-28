import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipe_app/app/data/models/store_model.dart';
import 'package:recipe_app/app/data/repositories/map_repository.dart';



class GroceryFinderController extends GetxController {
  final NominatimRepository _nominatimRepo = NominatimRepository();

 
  final userLocation = Rxn<LatLng>();
  final isFetchingLocation = false.obs;
  final locationError = "".obs;

 
  final selectedPoint = Rxn<LatLng>();

  final isReverseGeocoding = false.obs;
  final selectedStore = Rxn<StoreModel>();
  final geocodeError = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  Future<void> _initLocation() async {
    isFetchingLocation.value = true;
    locationError.value = "";

    try {
     
      final status = await Permission.location.request();

      if (status.isPermanentlyDenied) {
        locationError.value =
            "Location permission permanently denied. Enable it from app settings.";
        return;
      }
      if (!status.isGranted) {
        locationError.value = "Location permission is required to find nearby stores.";
        return;
      }

      
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = "Please enable location services (GPS).";
        return;
      }

     
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      locationError.value = "Could not fetch your location.\n$e";
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> retryLocationFetch() => _initLocation();

 
  Future<void> onMapPointSelected(LatLng point) async {
    selectedPoint.value = point;
    selectedStore.value = null;
    geocodeError.value = "";
    isReverseGeocoding.value = true;

    try {
      final address = await _nominatimRepo.reverseGeocode(
        latitude: point.latitude,
        longitude: point.longitude,
      );

      double distanceInMeters = 0;
      if (userLocation.value != null) {
        distanceInMeters = Geolocator.distanceBetween(
          userLocation.value!.latitude,
          userLocation.value!.longitude,
          point.latitude,
          point.longitude,
        );
      }

      selectedStore.value = StoreModel(
        latitude: point.latitude,
        longitude: point.longitude,
        address: address.displayName,
        city: address.city,
        state: address.state,
        country: address.country,
        distanceInMeters: distanceInMeters,
      );
    } catch (e) {
      geocodeError.value = "Could not fetch address for this location.\n$e";
    } finally {
      isReverseGeocoding.value = false;
    }
  }

  bool get canConfirm => selectedStore.value != null;
}
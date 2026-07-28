import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:recipe_app/app/modules/map/map_controller.dart';



class GroceryFinderView extends GetView<GroceryFinderController> {
  const GroceryFinderView({super.key});

// India, used until GPS resolves
  static const _fallbackCenter = LatLng(20.5937, 78.9629); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Grocery Store Finder")),
      body: Obx(() {
        if (controller.isFetchingLocation.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.locationError.value.isNotEmpty) {
          return _ErrorRetry(
            message: controller.locationError.value,
            onRetry: controller.retryLocationFetch,
          );
        }

        final center = controller.userLocation.value ?? _fallbackCenter;

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15,
                onTap: (tapPosition, point) => controller.onMapPointSelected(point),
                onLongPress: (tapPosition, point) => controller.onMapPointSelected(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.example.recipe_app",
                ),
                MarkerLayer(
                  markers: [
                    // User's current location marker (blue dot).
                    if (controller.userLocation.value != null)
                      Marker(
                        point: controller.userLocation.value!,
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    // The single selectable "store" marker - only ever one.
                    if (controller.selectedPoint.value != null)
                      Marker(
                        point: controller.selectedPoint.value!,
                        width: 44,
                        height: 44,
                        child: const Icon(Icons.location_pin, color: Colors.deepOrange, size: 44),
                      ),
                  ],
                ),
              ],
            ),

            // Hint banner before any selection is made
            if (controller.selectedPoint.value == null)
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Tap or long-press anywhere on the map to choose a grocery store location.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),

            // Bottom sheet with reverse-geocoded details + confirm button
            if (controller.selectedPoint.value != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _StoreDetailsSheet(),
              ),
          ],
        );
      }),
    );
  }
}

class _StoreDetailsSheet extends GetView<GroceryFinderController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Obx(() {
        if (controller.isReverseGeocoding.value) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.geocodeError.value.isNotEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                controller.geocodeError.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final store = controller.selectedStore.value;
        if (store == null) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selected Store", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(store.address, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text("City: ${store.city.isEmpty ? '-' : store.city}"),
            Text("State: ${store.state.isEmpty ? '-' : store.state}"),
            Text("Country: ${store.country.isEmpty ? '-' : store.country}"),
            Text(
              "Lat/Lng: ${store.latitude.toStringAsFixed(5)}, ${store.longitude.toStringAsFixed(5)}",
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 18, color: Colors.deepOrange),
                const SizedBox(width: 6),
                Text(store.distanceLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Returns the confirmed store to Recipe Details, which
                  // shows: address, distance, and the confirmation message.
                  Get.back(result: store);
                },
                child: const Text("Confirm Store"),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
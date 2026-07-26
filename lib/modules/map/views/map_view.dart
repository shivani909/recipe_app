import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Grocery Stores"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.currentAddress.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 300,
              child: fm.FlutterMap(
                options: fm.MapOptions(
                  initialCenter: controller.currentLocation.value,
                  initialZoom: 15,
                ),
                children: [
                  fm.TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.recipe_app',
                  ),

                  fm.MarkerLayer(
                    markers: [
                      // Your current location
                      fm.Marker(
                        point: controller.currentLocation.value,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 45,
                        ),
                      ),

                      // Nearby stores
                      ...controller.stores.map(
                        (store) => fm.Marker(
                          point: LatLng(store.latitude, store.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.local_grocery_store,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nearby Stores",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Expanded(
              child: controller.stores.isEmpty
                  ? const Center(child: Text("No nearby grocery stores found."))
                  : ListView.builder(
                      itemCount: controller.stores.length,
                      itemBuilder: (context, index) {
                        final store = controller.stores[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.store),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        store.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.distance < 1000
                                          ? "${store.distance.toStringAsFixed(0)} m away"
                                          : "${(store.distance / 1000).toStringAsFixed(1)} km away",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(store.address),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.openGoogleMaps(
                                        store.latitude,
                                        store.longitude,
                                      );
                                    },
                                    icon: const Icon(Icons.navigation),
                                    label: const Text("Directions"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Refresh Location"),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

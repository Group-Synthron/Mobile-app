// lib/screens/inventory_map/inventory_map_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trace2trade/screens/inventory/inventory_map_controller.dart';

class InventoryMapScreen extends StatelessWidget {
  const InventoryMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This line now CREATES the controller as soon as the screen is built,
    // which guarantees it will be available.
    final InventoryMapController controller = Get.put(InventoryMapController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Locations"),
        backgroundColor: const Color.fromARGB(255, 7, 100, 107),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // This check is crucial. If the API key is missing, it shows a helpful message
        // instead of crashing the app.
        if (controller.markers.isEmpty && !controller.isLoading.value) {
           return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No locations found or Google Maps API Key is missing/invalid. Please check your setup.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
        return GoogleMap(
          initialCameraPosition: controller.initialCameraPosition,
          markers: controller.markers.value,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        );
      }),
    );
  }
}

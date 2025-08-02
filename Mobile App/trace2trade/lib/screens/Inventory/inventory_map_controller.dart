import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trace2trade/models/inventory_location.dart';

class InventoryMapController extends GetxController {
  var markers = <Marker>{}.obs;
  var isLoading = true.obs;

  // Initial camera position can be set to a default location
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(6.9271, 79.8612), // Centered on Sri Lanka
    zoom: 8,
  );

  @override
  void onInit() {
    super.onInit();
    fetchInventoryLocations();
  }

  void fetchInventoryLocations() async {
    try {
      isLoading.value = true;
      // In a real app, you would fetch this data from a backend or smart contract.
      // For now, we'll use sample data.
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final List<InventoryLocation> locations = [
        InventoryLocation(id: '1', name: 'Catch #1', latitude: 6.9271, longitude: 79.8612),
        InventoryLocation(id: '2', name: 'Catch #2', latitude: 7.2906, longitude: 80.6337),
        InventoryLocation(id: '3', name: 'Catch #3', latitude: 6.0535, longitude: 80.2210),
        InventoryLocation(id: '4', name: 'Catch #4', latitude: 6.7969, longitude: 79.9018),

      ];

      // Create markers from the locations
      final newMarkers = locations.map((location) {
        return Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: 'Lat: ${location.latitude}, Lon: ${location.longitude}',
          ),
        );
      }).toSet();

      markers.value = newMarkers;
    } finally {
      isLoading.value = false;
    }
  }
}

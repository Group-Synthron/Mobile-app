// lib/screens/inventory_map/inventory_map_binding.dart

import 'package:get/get.dart';
import 'package:trace2trade/screens/inventory/inventory_map_controller.dart';

class InventoryMapBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily put the InventoryMapController into memory when the route is called.
    Get.lazyPut<InventoryMapController>(() => InventoryMapController());
  }
}

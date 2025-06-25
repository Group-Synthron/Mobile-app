import 'package:get/get.dart';
import 'package:trace2trade/screens/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily put the DashboardController into memory.
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
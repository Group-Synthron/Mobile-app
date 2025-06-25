import 'package:get/get.dart';
import 'package:trace2trade/screens/qrscan/qr_scan_controller.dart';

class QrScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScanController>(
      () => QrScanController(),
      fenix: true, // Allows recreation if needed
    );
  }
}
import 'package:get/get.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_controller.dart';

class BluetoothBinding extends Bindings {
  @override
  void dependencies() {
    // We use fenix: true to ensure the Bluetooth controller is not
    // destroyed if the user navigates away and comes back.
    Get.lazyPut<BluetoothController>(() => BluetoothController(), fenix: true);
  }
}

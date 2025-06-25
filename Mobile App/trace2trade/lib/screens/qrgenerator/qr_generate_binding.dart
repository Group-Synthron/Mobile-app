import 'package:get/get.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_controller.dart';

class QrGenerateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrGenerateController>(() => QrGenerateController());
  }
}

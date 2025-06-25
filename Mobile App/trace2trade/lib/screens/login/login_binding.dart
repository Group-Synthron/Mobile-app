import 'package:get/get.dart';
import 'package:trace2trade/screens/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily put the LoginController into memory.
    // It will be created only when it's first needed.
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

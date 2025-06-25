import 'package:get/get.dart';
import 'package:trace2trade/routes/app_routes.dart'; // You will need to create this

class WelcomeController extends GetxController {
  
  // Handles navigation to the login screen
  void navigateToLogin() {
    // Using GetX for navigation is clean and simple.
    // It assumes you have a '/login' route defined.
    Get.toNamed(Routes.LOGIN);
  }
}

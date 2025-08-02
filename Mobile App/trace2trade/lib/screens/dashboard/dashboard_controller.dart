import 'package:get/get.dart';
import 'package:trace2trade/routes/app_routes.dart';

class DashboardController extends GetxController {
  // Observable variables that the UI will listen to
  var totalCatches = 0.obs;
  var averageWeight = 0.0.obs;
  var lastLocation = "Unavailable".obs;
  var syncStatus = "Offline".obs;
  var userName = "User".obs; // Example user name

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data when the controller is first created
    refreshData();
  }

  // Simulates fetching fresh data from a service (like Firebase)
  void refreshData() {
    // In a real app, you would fetch this data from Firebase Firestore
    // For now, we'll use sample data
    totalCatches.value = 5;
    averageWeight.value = 2.53;
    lastLocation.value = "6.9271, 79.8612";
    syncStatus.value = "Synced just now";
    userName.value = "Admin";
  }

  void navigateToBluetooth() {
    Get.toNamed(Routes.BLUETOOTH);
  }

  void navigateToCreateContract() {
    Get.toNamed(Routes.CREATE_CONTRACT);
  }
  
  void navigateToAddCatch() {
    // You would create a new screen for this
    Get.snackbar("Navigate", "Navigate to Add New Catch Screen");
  }

  // --- New navigation method ---
  void navigateToInventoryMap() {
    Get.toNamed(Routes.INVENTORY_MAP);
  }

  void logout() {
    // Handle user logout logic here
    Get.offAllNamed(Routes.LOGIN);
  }
}

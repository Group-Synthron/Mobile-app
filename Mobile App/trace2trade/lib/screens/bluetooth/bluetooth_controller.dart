import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trace2trade/routes/app_routes.dart';

class BluetoothController extends GetxController {
  // Observable list to hold the scan results
  var scanResults = <ScanResult>[].obs;
  // Observable boolean to track scanning state
  var isScanning = false.obs;
  
  StreamSubscription? _scanSubscription;
  BluetoothDevice? connectedDevice;

  @override
  void onInit() {
    super.onInit();
    // Request permissions when the controller is initialized
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
      // Permissions are granted
    } else {
      Get.snackbar("Permissions Denied", "Bluetooth permissions are required to scan for devices.",
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Starts scanning for BLE devices
  void startScan() async {
    if (isScanning.value) return;

    // Check if Bluetooth is on
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      Get.snackbar("Bluetooth Off", "Please turn on Bluetooth to scan for devices.",
        snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    scanResults.clear();
    isScanning.value = true;
    
    try {
      // Start scanning for 10 seconds
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen to the results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        // Filter devices that have a name
        scanResults.value = results.where((r) => r.device.platformName.isNotEmpty).toList();
      });

    } catch (e) {
      Get.snackbar("Scan Error", "An error occurred while scanning: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM);
    } finally {
       // When the scan timeout is reached, stopScan is called automatically,
       // but we set a future here to ensure isScanning is reset.
       Future.delayed(const Duration(seconds: 10), () {
           isScanning.value = false;
       });
    }
  }

  // Stops scanning for BLE devices
  void stopScan() {
    isScanning.value = false;
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
  }

  // Connects to a selected device
  Future<void> connectToDevice(BluetoothDevice device) async {
    stopScan(); // Stop scanning before connecting
    try {
      Get.snackbar("Connecting...", "Connecting to ${device.platformName}",
        snackPosition: SnackPosition.BOTTOM, showProgressIndicator: true, duration: const Duration(seconds: 10));
      
      await device.connect(timeout: const Duration(seconds: 15));
      connectedDevice = device;
      
      Get.back(); // Close the progress snackbar
      Get.snackbar("Connected!", "Successfully connected to ${device.platformName}",
        snackPosition: SnackPosition.BOTTOM);
      
      // You are now connected. Navigate to the dashboard or another screen.
      Get.toNamed(Routes.DASHBOARD);

      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          Get.snackbar("Disconnected", "Lost connection to ${device.platformName}",
            snackPosition: SnackPosition.BOTTOM);
          connectedDevice = null;
        }
      });

    } catch (e) {
      Get.back(); // Close the progress snackbar
      Get.snackbar("Connection Failed", "Could not connect to ${device.platformName}: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  @override
  void onClose() {
    stopScan();
    connectedDevice?.disconnect();
    super.onClose();
  }
}

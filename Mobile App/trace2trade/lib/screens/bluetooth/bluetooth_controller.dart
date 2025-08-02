import 'dart:async';
import 'dart:convert'; // Required for utf8.decode
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/screens/dashboard/dashboard_controller.dart'; // Import dashboard controller

class BluetoothController extends GetxController {
  // Observable list to hold the scan results
  var scanResults = <ScanResult>[].obs;
  // Observable boolean to track scanning state
  var isScanning = false.obs;
  
  StreamSubscription? _scanSubscription;
  StreamSubscription<List<int>>? _dataSubscription;
  BluetoothDevice? connectedDevice;

  // --- UUIDs must match the ESP32 code ---
  final String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String characteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request multiple permissions for Bluetooth
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location, // Location is often required for BLE scanning
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted) {
      // Permissions are granted
      print("Bluetooth permissions granted.");
    } else {
      Get.snackbar("Permissions Denied", "Bluetooth & Location permissions are required.",
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  void startScan() async {
    if (isScanning.value) return;

    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      Get.snackbar("Bluetooth Off", "Please turn on Bluetooth.",
        snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    scanResults.clear();
    isScanning.value = true;
    
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results.where((r) => r.device.platformName.isNotEmpty).toList();
      });

    } catch (e) {
      Get.snackbar("Scan Error", "Error: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM);
    } finally {
       Future.delayed(const Duration(seconds: 10), () {
           if (isScanning.value) {
               isScanning.value = false;
               FlutterBluePlus.stopScan();
           }
       });
    }
  }

  void stopScan() {
    isScanning.value = false;
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    stopScan();
    try {
      Get.snackbar("Connecting...", "To ${device.platformName}",
        snackPosition: SnackPosition.BOTTOM, showProgressIndicator: true, duration: const Duration(seconds: 15));
      
      await device.connect(timeout: const Duration(seconds: 15));
      connectedDevice = device;
      
      Get.back(); // Close the progress snackbar
      Get.snackbar("Connected!", "Successfully connected to ${device.platformName}",
        snackPosition: SnackPosition.BOTTOM);
      
      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          Get.snackbar("Disconnected", "Lost connection",
            snackPosition: SnackPosition.BOTTOM);
          connectedDevice = null;
          _dataSubscription?.cancel();
        }
      });
      
      // --- Discover services and listen for data ---
      await _discoverServicesAndListen(device);

    } catch (e) {
      Get.back(); // Close the progress snackbar
      Get.snackbar("Connection Failed", "Could not connect: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _discoverServicesAndListen(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      print("Found ${services.length} services");
      
      for (var service in services) {
        print("Service UUID: ${service.uuid.toString().toLowerCase()}");
        
        // Check if this is the service we want (case insensitive)
        if (service.uuid.toString().toLowerCase() == serviceUuid.toLowerCase()) {
          print("Found target service!");
          
          for (var characteristic in service.characteristics) {
            print("Characteristic UUID: ${characteristic.uuid.toString().toLowerCase()}");
            
            // Check if this is the characteristic we want (case insensitive)
            if (characteristic.uuid.toString().toLowerCase() == characteristicUuid.toLowerCase()) {
              print("Found target characteristic!");
              
              // Subscribe to the characteristic
              await characteristic.setNotifyValue(true);
              _dataSubscription = characteristic.value.listen((value) {
                // New data received from the ESP32
                _handleReceivedData(value);
              });
              
              Get.snackbar("Ready", "Listening for data updates.", snackPosition: SnackPosition.BOTTOM);
              
              // Ensure DashboardController is registered before navigation
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
                print("DashboardController registered");
              }
              
              // Navigate to dashboard after successful subscription
              Get.toNamed(Routes.DASHBOARD);
              return; // Exit after finding and subscribing
            }
          }
        }
      }
      Get.snackbar("Service Not Found", "The required data service was not found on this device.", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Service Discovery Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _handleReceivedData(List<int> data) {
    try {
      String dataString = utf8.decode(data).trim();
      print("Raw received data: '$dataString'");

      List<String> parts = dataString.split(',');
      print("Data parts: $parts");
      
      if (parts.length >= 3) {
        final double lat = double.parse(parts[0].trim());
        final double lon = double.parse(parts[1].trim());
        final double weight = double.parse(parts[2].trim());
        
        print("Parsed - Lat: $lat, Lon: $lon, Weight: $weight");

        // Safe way to update dashboard
        if (Get.isRegistered<DashboardController>()) {
          final DashboardController dashboardController = Get.find();
          dashboardController.lastLocation.value = "${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}";
          dashboardController.averageWeight.value = weight;
          dashboardController.syncStatus.value = "Synced ${DateTime.now().toString().substring(11, 19)}";
          
          // Update total catches if weight > 0
          if (weight > 0.1) {
            dashboardController.totalCatches.value++;
          }
          
          print("Dashboard updated successfully");
          
          // Show success message
          Get.snackbar("Data Received", "GPS: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)} Weight: ${weight.toStringAsFixed(2)}kg",
              snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
              
        } else {
          print("DashboardController not found - registering it now");
          Get.put(DashboardController());
          // Try again after registering
          final DashboardController dashboardController = Get.find();
          dashboardController.lastLocation.value = "${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}";
          dashboardController.averageWeight.value = weight;
          dashboardController.syncStatus.value = "Synced ${DateTime.now().toString().substring(11, 19)}";
        }
      } else {
        print("Invalid data format - expected 3 parts, got ${parts.length}");
        Get.snackbar("Data Error", "Invalid data format received");
      }
    } catch (e) {
      print("Error handling received data: $e");
      Get.snackbar("Data Error", "Failed to process received data: $e");
    }
  }
  
  @override
  void onClose() {
    stopScan();
    _dataSubscription?.cancel();
    connectedDevice?.disconnect();
    super.onClose();
  }
}
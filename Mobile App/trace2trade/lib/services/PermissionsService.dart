import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PermissionsService {
  // Check if all required permissions are granted
  static Future<bool> checkAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
      Permission.storage,
    ].request();

    return statuses.values.every((status) => 
        status == PermissionStatus.granted || 
        status == PermissionStatus.limited);
  }

  // Request all permissions with user-friendly dialogs
  static Future<bool> requestAllPermissions() async {
    try {
      // Check current permission statuses
      bool cameraGranted = await _requestCameraPermission();
      bool bluetoothGranted = await _requestBluetoothPermissions();
      bool locationGranted = await _requestLocationPermission();
      bool storageGranted = await _requestStoragePermission();

      return cameraGranted && bluetoothGranted && locationGranted && storageGranted;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  // Request camera permission for QR scanning
  static Future<bool> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    
    if (status.isDenied) {
      // Show explanation dialog
      bool shouldRequest = await _showPermissionDialog(
        'Camera Permission',
        'Camera access is needed to scan QR codes for trading verification.',
        'Allow Camera',
      );
      
      if (shouldRequest) {
        status = await Permission.camera.request();
      }
    }
    
    if (status.isPermanentlyDenied) {
      await _showSettingsDialog('Camera permission is required for QR code scanning.');
      return false;
    }
    
    return status.isGranted;
  }

  // Request Bluetooth permissions
  static Future<bool> _requestBluetoothPermissions() async {
    List<Permission> bluetoothPermissions = [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ];

    bool shouldRequest = await _showPermissionDialog(
      'Bluetooth Permission',
      'Bluetooth access is needed to connect with trading devices and verify transactions.',
      'Allow Bluetooth',
    );

    if (!shouldRequest) return false;

    Map<Permission, PermissionStatus> statuses = await bluetoothPermissions.request();
    
    // Check if any are permanently denied
    bool anyPermanentlyDenied = statuses.values.any((status) => status.isPermanentlyDenied);
    if (anyPermanentlyDenied) {
      await _showSettingsDialog('Bluetooth permissions are required for device connectivity.');
      return false;
    }

    // Check if all are granted (or at least the essential ones)
    return statuses[Permission.bluetooth]?.isGranted == true ||
           statuses[Permission.bluetoothConnect]?.isGranted == true;
  }

  // Request location permission (needed for Bluetooth on Android)
  static Future<bool> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    
    if (status.isDenied) {
      bool shouldRequest = await _showPermissionDialog(
        'Location Permission',
        'Location access is required for Bluetooth functionality on Android devices.',
        'Allow Location',
      );
      
      if (shouldRequest) {
        status = await Permission.location.request();
      }
    }
    
    if (status.isPermanentlyDenied) {
      await _showSettingsDialog('Location permission is required for Bluetooth connectivity.');
      return false;
    }
    
    return status.isGranted;
  }

  // Request storage permission
  static Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    
    if (status.isDenied) {
      bool shouldRequest = await _showPermissionDialog(
        'Storage Permission',
        'Storage access is needed to save transaction documents and QR codes.',
        'Allow Storage',
      );
      
      if (shouldRequest) {
        status = await Permission.storage.request();
      }
    }
    
    if (status.isPermanentlyDenied) {
      await _showSettingsDialog('Storage permission is required for saving documents.');
      return false;
    }
    
    return status.isGranted;
  }

  // Show permission explanation dialog
  static Future<bool> _showPermissionDialog(String title, String message, String buttonText) async {
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(buttonText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  // Show settings dialog for permanently denied permissions
  static Future<void> _showSettingsDialog(String message) async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Permission Required'),
        content: Text('$message Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Quick permission checks for specific features
  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  static Future<bool> hasBluetoothPermission() async {
    bool bluetooth = await Permission.bluetooth.isGranted;
    bool bluetoothConnect = await Permission.bluetoothConnect.isGranted;
    return bluetooth || bluetoothConnect;
  }

  static Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }

  static Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted;
  }
}
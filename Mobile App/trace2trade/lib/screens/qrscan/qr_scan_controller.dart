import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

enum ScannerState { scanning, found, error }

class QrScanController extends GetxController with GetSingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();
  late final AnimationController animationController;

  var scannerState = ScannerState.scanning.obs;
  var hasPermission = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
    
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    isLoading.value = true;
    try {
      await _checkPermissions();
      if (hasPermission.value) {
        await cameraController.start();
      }
    } catch (e) {
      scannerState.value = ScannerState.error;
      Get.snackbar("Error", "Failed to initialize scanner",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkPermissions() async {
    try {
      var status = await Permission.camera.status;
      hasPermission.value = status.isGranted;
      if (!hasPermission.value) {
        status = await Permission.camera.request();
        hasPermission.value = status.isGranted;
      }
    } catch (e) {
      hasPermission.value = false;
      rethrow;
    }
  }
  
  Future<void> requestPermission() async {
    try {
      isLoading.value = true;
      final status = await Permission.camera.request();
      hasPermission.value = status.isGranted;
      if (hasPermission.value) {
        await cameraController.start();
      } else {
        Get.snackbar("Permission Denied", "Camera permission is required to scan QR codes.",
          backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to request permission",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void onQRCodeDetected(BarcodeCapture capture) {
    if (scannerState.value != ScannerState.scanning || isClosed) return;
    
    try {
      if (capture.barcodes.isEmpty) {
        scannerState.value = ScannerState.error;
        return;
      }

      scannerState.value = ScannerState.found;
      final String code = capture.barcodes.first.rawValue ?? 'No data found';
      
      _stopScanner();
      _showResultDialog(code);
    } catch (e) {
      scannerState.value = ScannerState.error;
      resumeScanner();
      Get.snackbar("Error", "Failed to process QR code",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _stopScanner() {
    try {
      cameraController.stop();
      animationController.stop();
    } catch (e) {
      debugPrint('Error stopping scanner: $e');
    }
  }

  void resumeScanner() {
    try {
      scannerState.value = ScannerState.scanning;
      cameraController.start();
      animationController.repeat();
    } catch (e) {
      debugPrint('Error resuming scanner: $e');
    }
  }

  void _showResultDialog(String code) {
    Get.defaultDialog(
      title: "QR Code Found!",
      middleText: code,
      backgroundColor: const Color(0xFF032E12),
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: "Copy",
      textCancel: "Scan Again",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white,
      buttonColor: Colors.greenAccent,
      barrierDismissible: false,
      onConfirm: () {
        if (!isClosed) {
          Clipboard.setData(ClipboardData(text: code));
          Get.back();
          Get.back();
          Get.snackbar("Copied!", "QR Code data copied to clipboard.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        }
      },
      onCancel: () => resumeScanner(),
    );
  }

void toggleFlashlight() {
  try {
    cameraController.toggleTorch();
  } catch (e) {
    debugPrint('Error toggling flashlight: $e');
    Get.snackbar(
      "Flashlight Error", 
      "Could not toggle flashlight",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  @override
  void onClose() {
    animationController.dispose();
    try {
      cameraController.dispose();
    } catch (e) {
      debugPrint('Error disposing camera controller: $e');
    }
    super.onClose();
  }
}
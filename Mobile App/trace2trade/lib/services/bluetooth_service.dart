import 'package:flutter/material.dart';

class BluetoothService {
  void scanDevices() {
    debugPrint("Scanning for Bluetooth devices...");
  }

  void connectToDevice(String deviceName) {
    debugPrint("Connecting to $deviceName");
  }
}
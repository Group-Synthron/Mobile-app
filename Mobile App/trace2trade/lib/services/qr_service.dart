import 'package:flutter/material.dart';

class QRService {
  String generateQRCode(String data) {
    return "QR:$data";
  }

  void scanQRCode() {
    debugPrint("QR code scanned");
  }
}
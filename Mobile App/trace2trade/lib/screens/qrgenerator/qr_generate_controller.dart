import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart'; // A package for sharing content

class QrGenerateController extends GetxController {
  // Controller for the text input field
  final textController = TextEditingController();
  
  // Observable string that will hold the data for the QR code
  // The UI will reactively show the QR code when this is not empty.
  var qrData = ''.obs;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // This function is called when the "Generate" button is pressed
  void generateQrCode() {
    final text = textController.text;
    if (text.isEmpty) {
      Get.snackbar(
        "Input Required",
        "Please enter some data to generate a QR code.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    // Update the qrData. The UI will automatically rebuild to show the new QR code.
    qrData.value = text;
  }
  
  // This function is called to share the generated QR data
  void shareQrCodeData() {
     if (qrData.value.isNotEmpty) {
       Share.share('Check out this data: ${qrData.value}');
     } else {
        Get.snackbar(
        "Nothing to Share",
        "Please generate a QR code first.",
        snackPosition: SnackPosition.BOTTOM,
      );
     }
  }
}

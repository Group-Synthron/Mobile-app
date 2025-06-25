import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/screens/qrgenerator/qr_generate_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';
import 'package:trace2trade/widgets/custom_input.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QrGenerateController controller = Get.find<QrGenerateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create a QR Code",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Enter any text or ID below to create a scannable QR code for your items.",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // The input field for the QR code data
            CustomInput(
              controller: controller.textController,
              label: "Data to encode",
            ),
            const SizedBox(height: 20),
            
            // The generate button
            CustomButton(
              label: "Generate",
              onPressed: () => controller.generateQrCode(),
            ),
            const SizedBox(height: 40),

            // This section will only appear after a QR code is generated
            Obx(() {
              if (controller.qrData.value.isEmpty) {
                // Show a placeholder before generation
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.qr_code_scanner, size: 100, color: AppColors.secondaryGray),
                      const SizedBox(height: 16),
                      Text("QR code will appear here", style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              } else {
                // Show the generated QR code
                return Column(
                  children: [
                    Text("Here is your QR Code:", style: TextStyle(color: Colors.grey[300], fontSize: 16)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: QrImageView(
                        data: controller.qrData.value,
                        version: QrVersions.auto,
                        size: 250.0,
                        // You can embed an image in the QR code
                        // embeddedImage: const AssetImage('assets/fish_logo.png'),
                        // embeddedImageStyle: const QrEmbeddedImageStyle(
                        //   size: Size(40, 40),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white, size: 30),
                      onPressed: () => controller.shareQrCodeData(),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/screens/bluetooth/bluetooth_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController controller = Get.find<BluetoothController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect to Device"),
        actions: [
          // Refresh/Scan button
          Obx(() => IconButton(
                icon: controller.isScanning.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Icon(Icons.refresh),
                onPressed: controller.isScanning.value ? null : () => controller.startScan(),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isScanning.value && controller.scanResults.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Scanning for devices...", style: TextStyle(color: AppColors.textLight)),
              ],
            ),
          );
        }

        if (controller.scanResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bluetooth_disabled, size: 80, color: AppColors.secondaryGray),
                const SizedBox(height: 20),
                const Text("No Devices Found", style: TextStyle(color: AppColors.textLight, fontSize: 22)),
                const SizedBox(height: 10),
                Text("Tap the refresh icon to start scanning.", style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          );
        }

        // Display the list of found devices
        return ListView.builder(
          itemCount: controller.scanResults.length,
          itemBuilder: (context, index) {
            final result = controller.scanResults[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.bluetooth, color: AppColors.textLight),
                title: Text(
                  result.device.platformName,
                  style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  result.device.remoteId.toString(),
                  style: TextStyle(color: Colors.grey[400]),
                ),
                onTap: () => controller.connectToDevice(result.device),
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() => CustomButton(
        label: controller.isScanning.value ? "Scanning..." : "Scan for Devices",
        onPressed: controller.isScanning.value ? () {} : () => controller.startScan(),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


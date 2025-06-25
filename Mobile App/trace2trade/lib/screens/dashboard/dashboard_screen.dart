import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/screens/dashboard/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // A modern, decorative app bar
          SliverAppBar(
            backgroundColor: AppColors.darkBg,
            pinned: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                "FISH INVENTORY",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.textLight.withOpacity(0.9),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.textLight),
                onPressed: () => controller.logout(),
              ),
            ],
          ),

          // Main content area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Stats Cards ---
                  _buildStatsCard(
                    title: "Total Catches Today",
                    value: controller.totalCatches.value.toString(),
                    icon: Icons.catching_pokemon, // Example icon
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  _buildStatsCard(
                    title: "Average Weight",
                    value: "${controller.averageWeight.value.toStringAsFixed(2)} kg",
                    icon: Icons.scale,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 16),
                  _buildStatsCard(
                    title: "Last GPS Location",
                    value: controller.lastLocation.value,
                    icon: Icons.location_on,
                    color: Colors.orangeAccent,
                  ),
                   const SizedBox(height: 16),
                  _buildStatsCard(
                    title: "Sync Status",
                    value: controller.syncStatus.value,
                    icon: Icons.sync,
                    color: Colors.purpleAccent,
                  ),
                  const SizedBox(height: 40),

                  // --- Action Buttons ---
                  _buildActionButton(
                    context: context,
                    iconPath: 'assets/bluetooth_icon.png', // <-- Provide your image asset
                    label: "Connect Device",
                    onTap: () => controller.navigateToBluetooth(),
                  ),
                  const SizedBox(height: 20),
                   _buildActionButton(
                    context: context,
                    iconPath: 'assets/add_catch_icon.png', // <-- Provide your image asset
                    label: "Add New Catch",
                    onTap: () => controller.navigateToAddCatch(),
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    context: context,
                    iconPath: 'assets/contract_icon.png', // <-- Provide your image asset
                    label: "Create Smart Contract",
                    onTap: () => controller.navigateToCreateContract(),
                  ),
                  _buildActionButton(
                    context: context,
                    iconPath: 'assets/qr_code_icon.png', // <-- Provide a new icon
                    label: "Generate QR Code",
                    onTap: () => Get.toNamed(Routes.QR_GENERATE),
                  ),
                  _buildActionButton(
                    context: context,
                    iconPath: 'assets/qr_scan_icon.png', // <-- Provide a new icon
                    label: "Scan QR Code",
                    onTap: () => Get.toNamed(Routes.QR_SCAN),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build the styled statistics cards
  Widget _buildStatsCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[300], fontSize: 16),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to build the large, icon-based action buttons
  Widget _buildActionButton({required BuildContext context, required String iconPath, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.secondaryGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryGreen, width: 2)
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 50, width: 50), // Using your image asset
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

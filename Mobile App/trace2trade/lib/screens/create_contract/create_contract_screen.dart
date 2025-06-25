import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/screens/create_contract/create_contract_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';
import 'package:trace2trade/widgets/custom_input.dart';

class CreateContractScreen extends StatelessWidget {
  const CreateContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateContractController controller = Get.find<CreateContractController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Vessel Contract'),
        backgroundColor: AppColors.primaryGreen,
      ),
       body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  controller.loadingMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16)
                ),
              ],
            )
          );
        }
         return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWalletStatusCard(controller),
              const SizedBox(height: 30),
              
              // ... (other existing widgets remain the same)
              
              CustomInput( 
                controller: controller.vesselNameController,
                label: 'Vessel Name',
                hintText: 'e.g., Ocean Explorer',
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: controller.registrationNumberController,
                label: 'Registration Number',
                hintText: 'e.g., SHIP123456',
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: controller.licensesController,
                label: 'Licenses (comma-separated)',
                hintText: 'e.g., Fishing, Transport, Tourism',
              ),
              const SizedBox(height: 40),
              
              // ... (rest of the existing code remains the same)
            ],
          ),
        );
      }),
    );
  }


  Widget _buildWalletStatusCard(CreateContractController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.isWalletConnected.value 
            ? AppColors.primaryGreen.withOpacity(0.2) 
            : AppColors.secondaryGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: controller.isWalletConnected.value 
              ? Colors.green 
              : AppColors.primaryGreen)
      ),
      child: controller.isWalletConnected.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  const Text("Wallet Connected", 
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 18)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => controller.disconnectWallet(), 
                    child: const Text("Disconnect", 
                        style: TextStyle(color: Colors.redAccent))
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Address: ${controller.connectedAddress.value}",
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("No Wallet Connected", 
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              CustomButton(
                label: "Connect Now",
                onPressed: () => controller.connectWallet(),
                backgroundColor: Colors.orange,
                minWidth: 150,
              ),
            ],
          ),
    ));
  }
}
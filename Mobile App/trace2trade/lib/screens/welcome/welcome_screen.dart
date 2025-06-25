import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/screens/welcome/welcome_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';
import 'package:trace2trade/constants/colors.dart'; // Assuming your colors are here

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller using GetX
    final WelcomeController controller = Get.put(WelcomeController());

    return Scaffold(
      backgroundColor: AppColors.darkBg, // Using the color from your palette
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // App Logo - Assuming you have an image in assets
              Image.asset(
                'assets/fish_logo.png', // Make sure you have this asset
                height: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 30),
              // Welcome Text
              const Text(
                "Welcome to",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              const Text(
                "FISH INVENTORY",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(flex: 3),
              // Get Started Button
              CustomButton(
                label: "Get Started",
                onPressed: () {
                  controller.navigateToLogin();
                },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

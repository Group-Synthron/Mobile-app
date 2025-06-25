import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/routes/app_routes.dart';
import 'package:trace2trade/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  // Text editing controllers for the input fields
  final emailController = TextEditingController(text: 'admin@example.com');
  final passwordController = TextEditingController(text: 'password123');
  
  // Observable boolean to track the loading state for the UI
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  @override
  void onClose() {
    // Dispose controllers when the controller is removed from memory
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggles password visibility in the UI
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  // Handles the login logic
  Future<void> login() async {
    try {
      isLoading.value = true; // Show loading indicator in the UI
      
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter both email and password.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Exit the function
      }

      final success = await _authService.login(email, password);

      if (success) {
        // Navigate to the dashboard on successful login, and clear
        // the navigation stack so the user can't go back to the login screen.
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid credentials. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Catch any other errors
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }
}

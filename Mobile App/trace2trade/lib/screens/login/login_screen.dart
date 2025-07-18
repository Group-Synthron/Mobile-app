import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trace2trade/constants/colors.dart';
import 'package:trace2trade/screens/login/login_controller.dart';
import 'package:trace2trade/widgets/custom_button.dart';
import 'package:trace2trade/widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put() to ensure the controller is created if not found
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Email Input Field
                  CustomInput(
                    controller: controller.emailController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 20),

                  // Password Input Field
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomInput(
                        controller: controller.passwordController,
                        label: 'Password',
                        obscureText: controller.isPasswordHidden.value,
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textLight.withOpacity(0.7),
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  if (controller.isLoading.value)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: "Login",
                        onPressed: () {
                          controller.login();
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () { /* TODO: Implement forgot password */ },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.textLight.withOpacity(0.7)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
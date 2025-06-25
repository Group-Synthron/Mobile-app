import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType; // Added for email input
  final IconData? icon; // Added for leading icon
  final Color? textColor; // New parameter for text color
  final Color? fillColor; // New parameter for fill color
  final Color? hintColor; // New parameter for hint text color

  const LoginTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.icon,
    this.textColor,
    this.fillColor,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType, // Apply keyboard type
      style: TextStyle(color: textColor ?? Colors.black), // Apply text color
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.grey[200], // Apply fill color
        prefixIcon: icon != null ? Icon(icon, color: hintColor ?? Colors.grey) : null, // Apply icon with hint color
        hintText: hint,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey), // Apply hint color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Slightly rounded corners for text fields
          borderSide: BorderSide.none, // Remove default border for filled fields
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: hintColor ?? Colors.blue, width: 2), // Highlight focused border
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Ocean Blue Theme
  static const Color primaryBlue = Color(0xFF1E88E5);      // Vibrant blue
  static const Color primaryDark = Color(0xFF0D47A1);      // Deep blue
  static const Color primaryLight = Color(0xFF64B5F6);     // Light blue
  
  // Secondary Colors - Complementary Teal
  static const Color secondaryTeal = Color(0xFF00ACC1);    // Teal accent
  static const Color secondaryLight = Color(0xFF4DD0E1);   // Light teal
  static const Color secondaryDark = Color(0xFF00838F);    // Dark teal
  
  // Background Colors
  static const Color darkBg = Color(0xFF0A0E27);           // Very dark blue
  static const Color cardBg = Color(0xFF1A1F3A);           // Dark blue card
  static const Color surfaceBg = Color(0xFF242B4D);        // Medium blue surface
  
  // Text Colors
  static const Color textLight = Color(0xFFE3F2FD);        // Light blue-white
  static const Color textSecondary = Color(0xFFB3E5FC);    // Muted light blue
  static const Color textDark = Color(0xFF37474F);         // Dark text
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);          // Green success
  static const Color warning = Color(0xFFFF9800);          // Orange warning
  static const Color error = Color(0xFFE53935);            // Red error
  static const Color info = Color(0xFF2196F3);             // Blue info
  
  // Accent Colors
  static const Color accentPurple = Color(0xFF7C4DFF);     // Purple accent
  static const Color accentGold = Color(0xFFFFB300);       // Gold accent
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryTeal, secondaryDark],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, primaryBlue],
  );
}
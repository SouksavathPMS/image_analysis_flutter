import 'package:flutter/material.dart';

class AppColors {
  // Build with AI Branding Colors
  static const Color primary = Color(0xFF4285F4); // Blue 500
  static const Color secondary = Color(0xFF34A853); // Green 500
  static const Color tertiary = Color(0xFFFBBC05); // Yellow 500
  static const Color error = Color(0xFFEA4335); // Red 500
  
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF1F3F4); // Google Grey 100
  static const Color onSurface = Color(0xFF202124);
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
}

class AppSizes {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  
  static const double borderRadius = 16.0;
  static const double buttonRadius = 24.0;
  static const double imagePlaceholderHeight = 250.0;
}

class AppStrings {
  static const String appTitle = 'Build with AI';
  static const String workshopTitle = 'Image Analysis Workshop';
  static const String takePhoto = 'Take Photo';
  static const String chooseFromGallery = 'Choose from Gallery';
  static const String analyzeImage = 'Analyze Image';
  static const String promptPlaceholder = 'What is in this picture?';
  static const String initialResponse = 'AI response will appear here';
}

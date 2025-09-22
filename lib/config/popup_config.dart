import 'package:flutter/material.dart';

/// Configuration for standardized popup dimensions across the app
class PopupConfig {
  // Standard popup dimensions (as percentage of screen size) - Increased by 10% width, 30% height
  static const double standardWidth =
      0.66; // 66% of screen width (was 60%, +10%)
  static const double standardHeight =
      0.65; // 65% of screen height (was 50%, +30%)

  // Large popup dimensions (for content-heavy popups) - Increased by 10% width, 30% height
  static const double largeWidth =
      0.825; // 82.5% of screen width (was 75%, +10%)
  static const double largeHeight =
      0.845; // 84.5% of screen height (was 65%, +30%)

  // Compact popup dimensions (for simple messages) - Increased by 10% width, 30% height
  static const double compactWidth =
      0.55; // 55% of screen width (was 50%, +10%)
  static const double compactHeight =
      0.52; // 52% of screen height (was 40%, +30%)

  // Maximum dimensions to prevent oversized popups - Increased to accommodate larger popups
  static const double maxWidth =
      800.0; // Maximum width in pixels (was 600, +33%)
  static const double maxHeight =
      700.0; // Maximum height in pixels (was 500, +40%)

  // Standard styling
  static const double borderRadius = 20.0;
  static const double shadowBlurRadius = 10.0;
  static const double shadowSpreadRadius = 5.0;
  static const double shadowOpacity = 0.3;

  // Background colors
  static const Color popupBackgroundColor = Color(
    0xFFF5F5F5,
  ); // Light gray background
  static const Color contentBackgroundColor = Color(
    0xFFE5E5E5,
  ); // Slightly darker gray for content areas

  // Header configuration
  static const double headerPadding = 20.0;
  static const double headerIconSize = 32.0;
  static const double headerFontSize = 20.0;

  // Content configuration
  static const double contentPadding = 30.0;
  static const double buttonHeight = 60.0;
}

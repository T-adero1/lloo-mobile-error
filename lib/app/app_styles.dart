import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global function for light/dark detection
isLightTheme() => Theme.of(Get.context!).brightness == Brightness.light;

/// INSTRUCTIONS FOR MODULE STYLES
/// - Make your ModuleStyles class
/// - Anything that is theme dependent (ie uses isLightTheme()) should be as a
///   getter (note some global styles use this too, e.g. defaultFont)
/// - Anything that is a shared style or base style (eg darkText color) place in AppStyles
///   and reference from your ModuleStyles
///
/// Global styles used throughout custom widgets
final class AppStyles {



  /////////////////////////
  // COLORS
  static get colors { return (
    black: Colors.black87,
    darkText: Colors.black87,
    lightText: Colors.white,

    background: isLightTheme() ? const Color(0xFFFFFFFF) : const Color(0xFF000000), // Pure white / Pure black
    surface: isLightTheme() ? const Color(0xFFF2F2F2) : const Color(0xFF1A1A1A),   // Off-white / Soft black
    divider: isLightTheme() ? const Color(0xFFCECECE) : const Color(0xFF2E2E2E),   // Light gray / Dark gray
    secondaryText: isLightTheme() ? const Color(0xFF808080) : const Color(0xFFAAAAAA), // Medium gray / Light gray
    primaryText: isLightTheme() ? const Color(0xFF000000) : const Color(0xFFFFFFFF), // Pure black / Pure white
    accent: const Color(0xFF3EB066), // Emerald green accent
  );}


}
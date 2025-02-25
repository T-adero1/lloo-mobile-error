import 'package:flutter/material.dart';

import 'app_styles.dart';


// constants/colors.dart
const kLightThemeColors = (
  background: Color(0xFFFFFFFF),
  secondaryText: Color(0xFF808080),
  primaryText: Color(0xFF000000),
  accent: Color(0xFF3EB066),
  surface: Color(0xFFF2F2F2),
  inverseText: Color(0xFFFFFFFF),
  divider: Color(0xFFCECECE),
);

const kDarkThemeColors = (
  background: Color(0xFF000000),
  surface: Color(0xFF1A1A1A),
  divider: Color(0xFF2E2E2E),
  secondaryText: Color(0xFFAAAAAA),
  primaryText: Color(0xFFFFFFFF),
  accent: Color(0xFF3EB066),
);

/// Not always obeyed but when it is, the spacing from the L/R edges
const kScreenPaddingSizeLR = 22.0;

const kLlooLogoWidth = 37.0;


class AppTheme {

  static TextStyle defaultFont({
    required double size,
    FontWeight? weight = FontWeight.w400,
    Color? color,
    double? lineHeight
  }) {
    return TextStyle(
      fontFamily: 'HelveticaNeue',
      fontSize: size,
      fontWeight: weight,
      height: lineHeight,
      color: color
    );
  }

  // ======================================================================
  // LIGHT THEME
  // ======================================================================
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kLightThemeColors.background,
    // canvasColor: kLightThemeColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: kLightThemeColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: kLightThemeColors.primaryText,
      elevation: 0,
      // divider line
      shape: Border()
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: kLightThemeColors.accent,
      surface: kLightThemeColors.surface,
      onSurface: kLightThemeColors.primaryText,
      primary: kLightThemeColors.primaryText,
      secondary: kLightThemeColors.secondaryText,
      tertiary: kLightThemeColors.accent,

      surfaceBright: kLightThemeColors.accent,
      onInverseSurface: kLightThemeColors.inverseText,

      // Use as a divider color
      outline: kLightThemeColors.divider,
    ),

    textTheme: TextTheme(
      // commented out means unused thus far
      // displayLarge: defaultFont(size: 57.0),
      // displayMedium: defaultFont(size: 45.0),
      // displaySmall: defaultFont(size: 36.0),

      headlineLarge: defaultFont(size: 27.0, lineHeight: 1.2, weight: FontWeight.w500),
      // headlineMedium: defaultFont(size: 24.0, weight: FontWeight.bold),
      // headlineSmall: defaultFont(size: 18.0, weight: FontWeight.bold),

      titleLarge: defaultFont(size: 24.0, weight: FontWeight.w500, lineHeight: 1.1),
      titleMedium: defaultFont(size: 19.0, weight: FontWeight.w500),
      titleSmall: defaultFont(size: 14.0, weight: FontWeight.w500),

      bodyLarge: defaultFont(size: 16.0),
      bodyMedium: defaultFont(size: 14.5, lineHeight: 1.1),
      bodySmall: defaultFont(size: 12.0),
      labelLarge: defaultFont(size: 14.0),
      labelMedium: defaultFont(size: 12.0),
      labelSmall: defaultFont(size: 11.0, lineHeight: 1.0),
    ),

    dividerTheme: DividerThemeData(
      color: kLightThemeColors.divider,
      indent: kScreenPaddingSizeLR,
      endIndent: kScreenPaddingSizeLR,
    ),


    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kLightThemeColors.accent,
        foregroundColor: kLightThemeColors.inverseText,
        textStyle: defaultFont(size: 13.0, weight: FontWeight.w600, color: kLightThemeColors.inverseText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      )
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: kLightThemeColors.background,
        foregroundColor: kLightThemeColors.primaryText,
        textStyle: defaultFont(size: 13.0, weight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        side: BorderSide(
          color: kLightThemeColors.primaryText, // Or whatever color you want for the outline
          width: 1.0, // Optional: specify border width
        ),
      )
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kLightThemeColors.surface,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide.none
      ),
    ),
  );


  // ======================================================================
  // DARK THEME
  // ======================================================================
  static final ThemeData dark = light; /*ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kDarkThemeColors.background,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: kDarkThemeColors.accent,
      surface: kDarkThemeColors.surface,
      onSurface: kDarkThemeColors.primaryText,
      secondary: kDarkThemeColors.secondaryText,
    ),
    // Copy other theme settings with dark colors
  );*/
}


//=======================================================================
// APP THEME HELPERS EXT
//=======================================================================

extension ThemeHelpers on ThemeData {
  // Define default font for the given context's primary color
  TextStyle defaultFont({
    required double size,
    FontWeight? weight,
    Color? color,
    double? lineHeight,
  }) {
    color ??= colorScheme.primary; // Access colorScheme property
    return AppTheme.defaultFont(size: size, weight: weight, color: color, lineHeight: lineHeight);
  }
}


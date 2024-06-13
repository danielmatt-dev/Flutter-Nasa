import 'package:flutter/material.dart';

import 'colors.dart';

// <>

const colorSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: LightColors.primary,
  onPrimary: LightColors.onPrimary,
  secondary: LightColors.secondary,
  onSecondary: LightColors.onSecondary,
  background: LightColors.background,
  onBackground: LightColors.onBackground,
  surface: LightColors.surface,
  onSurface: LightColors.onSurface,
  error: LightColors.error,
  onError: LightColors.onError,
);

const colorSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: DarkColors.primary,
  onPrimary: DarkColors.onPrimary,
  secondary: DarkColors.secondary,
  onSecondary: DarkColors.onSecondary,
  background: DarkColors.background,
  onBackground: DarkColors.onBackground,
  surface: DarkColors.surface,
  onSurface: DarkColors.onSurface,
  error: DarkColors.error,
  onError: DarkColors.onError,
);

class AppTheme {

  AppTheme();

  ThemeData getLightTheme(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeLight,
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: LightColors.surface,
          indicatorColor: Colors.blue.shade100,
          indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          labelTextStyle: getLabelTextStyle(LightColors.primary, height),
          iconTheme: MaterialStateProperty.all(
              IconThemeData(size: height * 0.03, color: LightColors.primary))
      ),
    );
  }
  
  ThemeData getDarkTheme(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return ThemeData(
        useMaterial3: true,
        colorScheme: colorSchemeDark,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade800,
          indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          labelTextStyle: getLabelTextStyle(DarkColors.onPrimary, height),
          iconTheme: MaterialStateProperty.all(
              IconThemeData(size: height * 0.03, color: DarkColors.onPrimary)),
        )
    );
  }

  MaterialStateProperty<TextStyle> getLabelTextStyle(Color color, double height) {
    return MaterialStateProperty.resolveWith((states) {

        final fontWeight = states.contains(MaterialState.selected)
            ? FontWeight.bold
            : FontWeight.w500;

        return TextStyle(
          fontSize: height * 0.015,
          fontWeight: fontWeight,
          color: color
        );
    });
  }

}

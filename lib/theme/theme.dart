import 'package:flutter/material.dart';

// Create an instance of MaterialTheme with the default text theme
final MaterialTheme materialTheme =
    MaterialTheme(Typography.material2021().black);

// Expose Light & Dark Themes for easy access
final ThemeData lightTheme = materialTheme.light();
final ThemeData darkTheme = materialTheme.dark();

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // Light Theme
  ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightScheme(),
      textTheme: textTheme.apply(
        bodyColor: lightScheme().onSurface,
        displayColor: lightScheme().onSurface,
      ),
    );
  }

  // Dark Theme
  ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkScheme(),
      textTheme: textTheme.apply(
        bodyColor: darkScheme().onSurface,
        displayColor: darkScheme().onSurface,
      ),
    );
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c6939),
      surfaceTint: Color(0xff3c6939),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbdf0b4),
      onPrimaryContainer: Color(0xff245023),
      secondary: Color(0xff53634f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd6e8ce),
      onSecondaryContainer: Color(0xff3b4b38),
      tertiary: Color(0xff38656a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcebf0),
      onTertiaryContainer: Color(0xff1e4d52),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff191d17),
      onSurfaceVariant: Color(0xff424940),
      outline: Color(0xff72796f),
      outlineVariant: Color(0xffc2c8bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa1d399),
      primaryFixed: Color(0xffbdf0b4),
      onPrimaryFixed: Color(0xff002203),
      primaryFixedDim: Color(0xffa1d399),
      onPrimaryFixedVariant: Color(0xff245023),
      secondaryFixed: Color(0xffd6e8ce),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbaccb3),
      onSecondaryFixedVariant: Color(0xff3b4b38),
      tertiaryFixed: Color(0xffbcebf0),
      onTertiaryFixed: Color(0xff002023),
      tertiaryFixedDim: Color(0xffa0cfd4),
      onTertiaryFixedVariant: Color(0xff1e4d52),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5eb),
      surfaceContainer: Color(0xffecefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa1d399),
      surfaceTint: Color(0xffa1d399),
      onPrimary: Color(0xff0b390f),
      primaryContainer: Color(0xff245023),
      onPrimaryContainer: Color(0xffbdf0b4),
      secondary: Color(0xffbaccb3),
      onSecondary: Color(0xff253423),
      secondaryContainer: Color(0xff3b4b38),
      onSecondaryContainer: Color(0xffd6e8ce),
      tertiary: Color(0xffa0cfd4),
      onTertiary: Color(0xff00363b),
      tertiaryContainer: Color(0xff1e4d52),
      onTertiaryContainer: Color(0xffbcebf0),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xFF121212),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc2c8bd),
      outline: Color(0xff8c9388),
      outlineVariant: Color(0xff424940),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff3c6939),
      primaryFixed: Color(0xffbdf0b4),
      onPrimaryFixed: Color(0xff002203),
      primaryFixedDim: Color(0xffa1d399),
      onPrimaryFixedVariant: Color(0xff245023),
      secondaryFixed: Color(0xffd6e8ce),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbaccb3),
      onSecondaryFixedVariant: Color(0xff3b4b38),
      tertiaryFixed: Color(0xffbcebf0),
      onTertiaryFixed: Color(0xff002023),
      tertiaryFixedDim: Color(0xffa0cfd4),
      onTertiaryFixedVariant: Color(0xff1e4d52),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xFF303030),
    );
  }
}

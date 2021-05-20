import 'package:flutter/material.dart';

abstract class MemoryPathColors {
  Color get darkBlue;
  Color get onDarkBlue;
  Color get blue;
  Color get onBlue;
  Color get light;
  Color get onLight;
  Color get darkRed;
  Color get onDarkRed;
  Color get orange;
  Color get onOrange;
}

class DarkColors extends MemoryPathColors {
  @override
  Color get darkBlue => const Color(0xFF001524);
  @override
  Color get blue => const Color(0xFF15616D);
  @override
  Color get light => const Color(0xFFFFECD1);
  @override
  Color get darkRed => const Color(0xFF78290F);
  @override
  Color get orange => const Color(0xFFFF7D00);
  @override
  Color get onDarkBlue => Colors.white;
  @override
  Color get onBlue => orange;
  @override
  Color get onLight => darkRed;
  @override
  Color get onDarkRed => light;
  @override
  Color get onOrange => darkBlue;
}

class LightColors extends MemoryPathColors {
  @override
  Color get darkBlue => const Color(0xFF001524);
  @override
  Color get blue => const Color(0xFF003742);
  @override
  Color get light => const Color(0xFFFFECD1);
  @override
  Color get darkRed => const Color(0xFF490000);
  @override
  Color get orange => const Color(0xFFc54e00);
  @override
  Color get onDarkBlue => Colors.white;
  @override
  Color get onBlue => Colors.white;
  @override
  Color get onLight => Colors.white;
  @override
  Color get onDarkRed => Colors.white;
  @override
  Color get onOrange => Colors.white;
}

final MemoryPathColors _darkColors = DarkColors();
final MemoryPathColors _lightColors = LightColors();

ColorScheme _darkColorScheme = ColorScheme(
  primary: _darkColors.darkBlue,
  primaryVariant: _darkColors.blue,
  secondary: _darkColors.orange,
  secondaryVariant: _darkColors.darkRed,
  surface: _darkColors.light,
  background: _darkColors.light,
  error: _darkColors.darkRed,
  onPrimary: _darkColors.onDarkBlue,
  onSecondary: _darkColors.onOrange,
  onSurface: _darkColors.onLight,
  onBackground: _darkColors.onLight,
  onError: _darkColors.onDarkRed,
  brightness: Brightness.dark,
);

ColorScheme _lightColorScheme = ColorScheme(
  primary: _lightColors.darkBlue,
  primaryVariant: _lightColors.blue,
  secondary: _lightColors.orange,
  secondaryVariant: _lightColors.darkRed,
  surface: _lightColors.light,
  background: _lightColors.light,
  error: _lightColors.darkRed,
  onPrimary: _lightColors.onDarkBlue,
  onSecondary: _lightColors.onOrange,
  onSurface: _lightColors.onLight,
  onBackground: _lightColors.onLight,
  onError: _lightColors.onDarkRed,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  colorScheme: _darkColorScheme,
);

ThemeData lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
);

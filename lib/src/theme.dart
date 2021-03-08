import 'package:flutter/material.dart';

final primaryColor = Colors.lightGreen;
final cardTheme = CardTheme(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))));

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    cardTheme: cardTheme);

final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    cardTheme: cardTheme);

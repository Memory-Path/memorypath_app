import 'package:flutter/material.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/MemoryPointEditPage.dart';
import 'package:mobile/pages/SplashScreen.dart';
import 'package:mobile/src/RouteNotFoundException.dart';

void main() {
  runApp(MyApp());
}

final baseTheme =
    ThemeData(brightness: Brightness.dark, primaryColor: Colors.lightGreen);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory-Path',
      theme: baseTheme.copyWith(brightness: Brightness.light),
      darkTheme: baseTheme,
      initialRoute:
          '/', // this can be used during development to access a requested page right when opening the app
      onGenerateRoute: (routeSettings) {
        // For web persistence reasons, please do not use arguments when pushing routes.
        // ```dart
        // Navigator.of(context)
        //     .pushNamed('/whatever', arguments: widget.data); /// NO ARGUMENTS, only Strings please. Data is dynamically built based on the route name.
        // ```
        if (SplashScreen.routeMatch.hasMatch(routeSettings.name)) {
          return MaterialPageRoute(builder: (context) => SplashScreen());
        }
        if (HomePage.routeMatch.hasMatch(routeSettings.name)) {
          return MaterialPageRoute(builder: (context) => HomePage());
        }
        if (MemoryPointEditPage.routeMatch.hasMatch(routeSettings.name)) {
          final match =
              MemoryPointEditPage.routeMatch.firstMatch(routeSettings.name);
          int point = int.parse(match.group(1));
          return MaterialPageRoute(
              builder: (context) => MemoryPointEditPage(
                    memoryPointId: point,
                  ));
        }
        return MaterialPageRoute(
            builder: (context) =>
                SplashScreen(data: RouteNotFoundException(routeSettings.name)));
      },
      home: SplashScreen(),
    );
  }
}

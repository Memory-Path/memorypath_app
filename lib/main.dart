import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/CreateMemoryPathPage.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/MemoryPointEditPage.dart';
import 'package:mobile/pages/SplashScreen.dart';
import 'package:mobile/src/RouteNotFoundException.dart';
import 'package:mobile/src/theme.dart';

bool initialized = false;

Box<MemoryPathDb> databaseBox;
Box settingsBox;

void main() async {
  await initHive();
  //Hive.registerAdapter(MemoryPathDbAdapter());
  //Hive.registerAdapter(MemoryPointDbAdapter());
  runApp(MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MemoryPathDbAdapter());
  Hive.registerAdapter(MemoryPointDbAdapter());
  settingsBox = await Hive.openBox(HIVE_SETTINGS);
  databaseBox = await Hive.openBox<MemoryPathDb>(HIVE_MEMORY_PATHS);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HIVE_SETTINGS).listenable(),
      builder: (context, box, widget) {
        final isDarkTheme = box.get('darkMode', defaultValue: true);

        return MaterialApp(
          title: 'Memory-Path',
          theme: isDarkTheme ? darkTheme : lightTheme,
          darkTheme: darkTheme,
          initialRoute:
              '/', // this can be used during development to access a requested page right when opening the app
          onGenerateRoute: (routeSettings) {
            // For web persistence reasons, please do not use arguments when pushing routes.
            // ```dart
            // Navigator.of(context)
            //     .pushNamed('/whatever', arguments: widget.data); /// NO ARGUMENTS, only Strings please. Data is dynamically built based on the route name.
            // ```

            // initialize whole application first before pushing any route
            // then, the [SplashScreen] will redirect here to get to the actual route
            if (!initialized)
              return MaterialPageRoute(
                  builder: (context) => SplashScreen(
                        requestedRoute: routeSettings.name,
                      ));
            else if (SplashScreen.routeMatch.hasMatch(routeSettings.name)) {
              return MaterialPageRoute(builder: (context) => SplashScreen());
            } else if (HomePage.routeMatch.hasMatch(routeSettings.name)) {
              return MaterialPageRoute(builder: (context) => HomePage());
            } else if (CreateMemoryPathPage.routeMatch
                .hasMatch(routeSettings.name)) {
              return MaterialPageRoute(
                  builder: (context) => CreateMemoryPathPage());
            } else if (MemoryPointEditPage.routeMatch
                .hasMatch(routeSettings.name)) {
              final match =
                  MemoryPointEditPage.routeMatch.firstMatch(routeSettings.name);
              int point = int.parse(match.group(1));
              return MaterialPageRoute(
                  builder: (context) => MemoryPointEditPage(
                        memoryPointId: point,
                      ));
            } else {
              return MaterialPageRoute(
                  builder: (context) => HomePage(
                      data: RouteNotFoundException(routeSettings.name)));
            }
          },
          routes: {
            '/': (context) => SplashScreen(),
          },
        );
      },
    );
  }
}

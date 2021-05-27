import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/EditMemoryPathPage.dart';
import 'package:mobile/pages/EditMemoryPointPage.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/PracticePage.dart';
import 'package:mobile/pages/SplashScreen.dart';
import 'package:mobile/src/RouteNotFoundException.dart';
import 'package:mobile/theme/theme.dart';

bool initialized = false;

late Box<MemoryPathDb> databaseBox;
late Box<dynamic> settingsBox;

Future<void> main() async {
  await initHive();
  //Hive.registerAdapter(MemoryPathDbAdapter());
  //Hive.registerAdapter(MemoryPointDbAdapter());
  runApp(MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MemoryPathDbAdapter());
  Hive.registerAdapter(MemoryPointDbAdapter());
  settingsBox = await Hive.openBox<dynamic>(HIVE_SETTINGS);
  databaseBox = await Hive.openBox<MemoryPathDb>(HIVE_MEMORY_PATHS);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: Hive.box<dynamic>(HIVE_SETTINGS).listenable(),
      builder: (BuildContext context, Box<dynamic> box, Widget? widget) {
        final bool isDarkTheme =
            box.get('darkMode', defaultValue: true) as bool;

        return MaterialApp(
          title: 'Memory-Path',
          theme: isDarkTheme ? darkTheme : lightTheme,
          darkTheme: darkTheme,
          initialRoute:
              '/', // this can be used during development to access a requested page right when opening the app
          onGenerateRoute: (RouteSettings routeSettings) {
            // For web persistence reasons, please do not use arguments when pushing routes.
            // ```dart
            // Navigator.of(context)
            //     .pushNamed('/whatever', arguments: widget.data); /// NO ARGUMENTS, only Strings please. Data is dynamically built based on the route name.
            // ```

            // initialize whole application first before pushing any route
            // then, the [SplashScreen] will redirect here to get to the actual route
            if (!initialized)
              return MaterialPageRoute<SplashScreen>(
                  builder: (BuildContext context) => SplashScreen(
                        requestedRoute: routeSettings.name,
                      ));
            else if (SplashScreen.routeMatch.hasMatch(routeSettings.name!)) {
              return MaterialPageRoute<SplashScreen>(
                  builder: (BuildContext context) => const SplashScreen());
            } else if (HomePage.routeMatch.hasMatch(routeSettings.name!)) {
              return MaterialPageRoute<HomePage>(
                  builder: (BuildContext context) => const HomePage());
            } else if (EditMemoryPathPage.routeMatch
                .hasMatch(routeSettings.name!)) {
              final RegExpMatch match =
                  EditMemoryPathPage.routeMatch.firstMatch(routeSettings.name!)!;
              int? path;
              if (match.group(2) != null) {
                path = int.parse(match.group(2)!);
              }
              return MaterialPageRoute<EditMemoryPathPage>(
                  builder: (BuildContext context) =>
                      EditMemoryPathPage(path: path));
            } else if (MemoryPointEditPage.routeMatch
                .hasMatch(routeSettings.name!)) {
              final RegExpMatch match =
                  MemoryPointEditPage.routeMatch.firstMatch(routeSettings.name!)!;
              final int path = int.parse(match.group(1)!);
              final int point = int.parse(match.group(2)!);
              return MaterialPageRoute<MemoryPointEditPage>(
                  builder: (BuildContext context) => MemoryPointEditPage(
                        memoryPointId: point,
                        memoryPathId: path,
                      ));
            } else if (PracticePage.routeMatch.hasMatch(routeSettings.name!)) {
              final RegExpMatch match =
                  PracticePage.routeMatch.firstMatch(routeSettings.name!)!;
              final int path = int.parse(match.group(1)!);
              return MaterialPageRoute<PracticePage>(
                  builder: (BuildContext context) => PracticePage(
                        memoryPath: path,
                      ));
            } else {
              return MaterialPageRoute<HomePage>(
                  builder: (BuildContext context) => HomePage(
                      data: RouteNotFoundException(routeSettings.name)));
            }
          },
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => const SplashScreen(),
          },
        );
      },
    );
  }
}

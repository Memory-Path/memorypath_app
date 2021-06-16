import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/EditMemoryPathPage.dart';
import 'package:mobile/src/HeroTags.dart';
//import 'package:mobile/src/MemoryPath.dart';
import 'package:mobile/src/RouteNotFoundException.dart';
import 'package:mobile/widgets/MemoryPathCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.data}) : super(key: key);
  static final RegExp routeMatch = RegExp(r'^\/home$');
  final dynamic data;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _manuallyHideRoutingError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Box<MemoryPathDb> _box = Hive.box<MemoryPathDb>(HIVE_MEMORY_PATHS);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 4),
        child: ListView(
          padding: const EdgeInsets.all(2),
          children: <Widget>[
            if (widget.data != null &&
                widget.data is RouteNotFoundException &&
                !_manuallyHideRoutingError)
              ListTile(
                leading: const Icon(
                  Icons.info_outlined,
                  color: Colors.deepOrange,
                ),
                title: const Text(
                    'Error 404 - We could not find what you were looking for.'),
                subtitle: Text(
                    'The location ${(widget.data as RouteNotFoundException).name} does not seem to exist.'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Hide',
                  onPressed: () =>
                      setState(() => _manuallyHideRoutingError = true),
                ),
              ),
            // TODO(MemoryPath): Replace by dynamic User-Info
            ListTile(
              leading: Text(
                'Hey User',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: const Icon(Icons.person),
            ),
            ListTile(
              leading: Text(
                'My Paths',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2 * 3),
                child: ValueListenableBuilder<Box<MemoryPathDb>>(
                  valueListenable: _box.listenable(),
                  builder: (BuildContext context, Box<MemoryPathDb> box,
                      Widget? widget) {
                    //Added Quickfix
                    final List<MemoryPathDb> paths = listAllMemoryPath(box);
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (paths.isEmpty)
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: 250,
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2),
                              child: AspectRatio(
                                  aspectRatio:
                                      MediaQuery.of(context).size.aspectRatio,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'So lonely here...\nMaybe you would like to create a new Memory-Path?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ...paths.map((MemoryPathDb e) => MemoryPathCard(
                                memoryPath: e,
                              )),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: OpenContainer(
                      //     closedColor: Theme.of(context).cardColor,
                      //     closedShape: Theme.of(context).cardTheme.shape!,
                      //     closedBuilder: (BuildContext c, VoidCallback f) =>
                      //         Container(
                      //       constraints: const BoxConstraints(minWidth: 64),
                      //       child: AspectRatio(
                      //         aspectRatio:
                      //             MediaQuery.of(context).size.aspectRatio / 4,
                      //         child: const Tooltip(
                      //           child: Hero(
                      //               tag: HeroTags.AddPathIcon,
                      //               child: Icon(Icons.add)),
                      //           message: 'Create memory path',
                      //         ),
                      //         /*onPressed: () {
                      //               */ /*setState(
                      //                       () => _addingPath = true);*/ /*
                      //             },*/
                      //       ),
                      //     ),
                      //     routeSettings:
                      //         const RouteSettings(name: '/createPath'),
                      //     openBuilder: (BuildContext c, VoidCallback f) =>
                      //         EditMemoryPathPage(
                      //       onCreated: (MemoryPathDb data) {
                      //         print('Data!');
                      //       },
                      //     ),
                      //     openColor: Theme.of(context).backgroundColor,
                      //   ),
                      // ),
                    );
                  },
                )),
          ],
        ),
      ),
      // TODO(MemoryPath): Button Shape & Color,
      floatingActionButton: OpenContainer(
        closedColor: Theme.of(context).colorScheme.onSecondary,
        closedShape: Theme.of(context).cardTheme.shape!,
        openBuilder: (BuildContext c, VoidCallback f) => EditMemoryPathPage(
          onCreated: (MemoryPathDb data) {},
        ),
        openColor: Theme.of(context).backgroundColor,
        closedBuilder: (BuildContext c, VoidCallback f) => Container(
          child: const Tooltip(
            child: Hero(tag: HeroTags.AddPathIcon, child: Icon(Icons.add)),
            message: 'Create Memory-Path',
          ),
        ),
        routeSettings: const RouteSettings(name: '/createPath'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // TODO(MemoryPath): How to navigate to specific Route?
        onTap: null,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), tooltip: 'Go to Homepage', label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              tooltip: 'Show all Memory-Paths',
              label: 'showAll'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              tooltip: 'Go to Profile',
              label: 'profile')
        ],
      ),
    );
  }

  List<MemoryPathDb> listAllMemoryPath(Box<MemoryPathDb> box) {
    final List<MemoryPathDb> memoryPaths = <MemoryPathDb>[];
    memoryPaths.addAll(box.values);
    return memoryPaths;
  }
}

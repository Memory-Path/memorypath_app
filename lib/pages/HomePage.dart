import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/CreateMemoryPathPage.dart';
//import 'package:mobile/src/MemoryPath.dart';
import 'package:mobile/src/RouteNotFoundException.dart';
import 'package:mobile/widgets/MemoryPathCard.dart';

class HomePage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/home$');
  final dynamic data;

  const HomePage({Key key, this.data}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _manuallyHideRoutingError = false;

  @override
  void initState() {
    //loadMemoryPaths();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.data != null &&
                widget.data is RouteNotFoundException &&
                !_manuallyHideRoutingError)
              ListTile(
                leading: Icon(
                  Icons.info_outlined,
                  color: Colors.deepOrange,
                ),
                title: Text(
                    'Error 404 - We could not find what you were looking for.'),
                subtitle: Text(
                    'The location ${(widget.data as RouteNotFoundException).name} does not seem to exist.'),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  tooltip: 'Hide',
                  onPressed: () =>
                      setState(() => _manuallyHideRoutingError = true),
                ),
              ),
            Text(
              'My paths',
              style: Theme.of(context).textTheme.headline3,
            ),
            Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(HIVE_MEMORY_PATHS).listenable(),
                  builder: (context, Box box, widget) {
                    final List<MemoryPathDb> paths = box
                        .get(HIVE_MEMORY_PATHS, defaultValue: <MemoryPathDb>[]);
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: OpenContainer(
                            closedColor: Theme.of(context).cardColor,
                            closedShape: Theme.of(context).cardTheme.shape,
                            closedBuilder: (c, f) => Container(
                              constraints: BoxConstraints(minWidth: 64),
                              child: AspectRatio(
                                aspectRatio:
                                    MediaQuery.of(context).size.aspectRatio / 4,
                                child: Tooltip(
                                  child: Icon(Icons.add),
                                  message: 'Create memory path',
                                ),
                                /*onPressed: () {
                                      */ /*setState(
                                              () => _addingPath = true);*/ /*
                                    },*/
                              ),
                            ),
                            routeSettings: RouteSettings(name: '/createPath'),
                            openBuilder: (c, f) => CreateMemoryPathPage(
                              onCreated: (data) {
                                print('Data!');
                              },
                            ),
                            openColor: Theme.of(context).backgroundColor,
                          ),
                        ),
                        if (paths.isEmpty)
                          Container(
                            constraints: BoxConstraints(maxWidth: 393),
                            child: AspectRatio(
                                aspectRatio:
                                    MediaQuery.of(context).size.aspectRatio,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'So lonely here...\nMaybe you would like to create a new Memory-Path?',
                                      ),
                                    ),
                                  ),
                                )),
                          )
                      ]..addAll(paths.map((e) => MemoryPathCard(
                            memoryPath: e,
                          ))),
                    );
                  },
                )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 786),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    'Here, some stats can be shown as soon as the DB is working properly.'),
              ),
            ),
          ),
        ),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 5),
      ),
    );
  }
}

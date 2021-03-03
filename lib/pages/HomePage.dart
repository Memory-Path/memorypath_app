import 'package:flutter/material.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/src/MemoryPath.dart';
import 'package:mobile/src/RouteNotFoundException.dart';
import 'package:mobile/widgets/CenterProgress.dart';
import 'package:mobile/widgets/CreateMemoryPathCard.dart';
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
  bool _memoryPathsLoaded = false;

  bool _addingPath = false;

  List<MemoryPath> _paths = [];

  // TODO: wait for DB fixes
  //MemoryPathDatabaseApi db = MemoryPathDatabaseApi();

  @override
  void initState() {
    loadMemoryPaths();
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
              child: _memoryPathsLoaded
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        !_addingPath
                            ? Container(
                                constraints: BoxConstraints(minWidth: 64),
                                child: AspectRatio(
                                  aspectRatio:
                                      MediaQuery.of(context).size.aspectRatio /
                                          4,
                                  child: Card(
                                    child: Hero(
                                      tag: HeroTags.AddPathIcon,
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            setState(() => _addingPath = true),
                                        tooltip: 'Create memory path',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : CreateMemoryPathCard(),
                        if (_paths.isEmpty)
                          Container(
                            constraints: BoxConstraints(maxWidth: 393),
                            child: AspectRatio(
                                aspectRatio:
                                    MediaQuery.of(context).size.aspectRatio,
                                child: Card(
                                  child: Center(
                                    child: Text(
                                      'So lonely here...\nMaybe you would like to create a new Memory-Path?',
                                    ),
                                  ),
                                )),
                          )
                      ]..addAll(_paths.map((e) => MemoryPathCard(
                            memoryPath: e,
                          ))),
                    )
                  : CenterProgress(),
            ),
            Expanded(child: Container()),
            Center(
                child: Container(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        'Here, some stats can be shown as soon as the DB is working properly.'),
                  ),
                ),
              ),
              constraints: BoxConstraints(
                  maxWidth: 786,
                  minHeight: MediaQuery.of(context).size.height / 5),
            )),
          ],
        ),
      ),
    );
  }

  void loadMemoryPaths() async {
    //db;
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _memoryPathsLoaded = true;
    });
  }
}

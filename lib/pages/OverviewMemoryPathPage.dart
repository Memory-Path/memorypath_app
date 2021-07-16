import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/MemoryPathImageDisplayer.dart';
import 'package:mobile/widgets/SimpleImageDisplayer.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

/// Page to show the Overview of a MemoryPath before you start Learning
class OverviewMemoryPathPage extends StatefulWidget {
  const OverviewMemoryPathPage({Key? key, this.memoryPath}) : super(key: key);
  static final RegExp routeMatch = RegExp(r'^\/overview\/(\d+)$');
  final int? memoryPath;

  @override
  _OverviewMemoryPathPageState createState() => _OverviewMemoryPathPageState();
}

class _OverviewMemoryPathPageState extends State<OverviewMemoryPathPage>
    with TickerProviderStateMixin {
  late MemoryPathDb? memoryPath;
  final ScrollController _listViewController = ScrollController();

  final SnappingSheetController _sheetController = SnappingSheetController();

  late TabController _tabController;

  @override
  void initState() {
    final MemoryPathDb? path = databaseBox.get(widget.memoryPath);
    if (path == null) {
      Navigator.of(context).pop();
    }
    memoryPath = path!;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[Tab(text: 'Map'), Tab(text: 'Image')],
        ),
      ),
      // TODO(TheOneWithTheBraid): Layout- and Functionality-Update
      body: SnappingSheet(
        controller: _sheetController,
        lockOverflowDrag: true,
        sheetAbove: null,
        snappingPositions: const <SnappingPosition>[
          SnappingPosition.pixels(positionPixels: 24),
          SnappingPosition.factor(positionFactor: .5),
          SnappingPosition.factor(positionFactor: .9),
        ],
        grabbingHeight: 48,
        grabbing: Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Center(
            child: Container(
              height: 8,
              width: 48,
              child: Tooltip(
                message: 'Drag to open',
                child: Material(
                  elevation: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ),
        ),
        sheetBelow: SnappingSheetContent(
            childScrollController: _listViewController,
            draggable: true,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                controller: _listViewController,
                itemCount: memoryPath!.memoryPoints!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _memoryPointListTile(memoryPath!.memoryPoints![index]);
                },
              ),
            )),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5 * 4,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                StaticMapView(points: memoryPath!.memoryPoints!),
                MemoryPathImageDisplayer(
                  memoryPath: memoryPath!,
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, '/practice/${widget.memoryPath}'),
        label: const Text('Start Learning'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // TODO(TheOneWithTheBraid): Integration of Widgets and Clean up - Elements in draft commented underneath
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          title: Text(memoryPath!.name!),
          subtitle: Text(memoryPath!.topic!),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.pushNamed(context, '/editPath/${widget.memoryPath}'),
          ),
        ),
        // ListView(
        //   children: [
        //     // ListTile(
        //     //   leading: const Icon(Icons.auto_graph),
        //     //   title: Text(memoryPath!.memoryPoints!.length.toString()),
        //     // ),
        //     // ListTile(
        //     //   leading: const Icon(Icons.copy_outlined),
        //     //   title: Text(memoryPath!.memoryPoints!.length.toString()),
        //     // ),
        //     // ListTile(
        //     //   leading: const Icon(Icons.access_time),
        //     //   title: Text(memoryPath!.memoryPoints!.length.toString()),
        //     // ),
        //   ],
        // ),
      ),
    );
  }

  // Simple ListTile for displaying MemoryPoints in SnappingSheet
  Widget _memoryPointListTile(MemoryPointDb memoryPoint) {
    if (memoryPoint.name != null) {
      return ListTile(
        leading: CircleAvatar(
          child: ClipRRect(
            child: SimpleImageDisplayer(path: memoryPoint.image),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        title: Text(memoryPoint.name!),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          child: ClipRRect(
            child: SimpleImageDisplayer(path: memoryPoint.image),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        title: const Text('no data'),
      );
    }
  }
}

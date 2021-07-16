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

class _OverviewMemoryPathPageState extends State<OverviewMemoryPathPage> {
  MemoryPathDb? memoryPath;
  final ScrollController _listViewController = ScrollController();
  bool _mapDisplayed = false;

  @override
  void initState() {
    memoryPath = databaseBox.get(widget.memoryPath);
    // TODO(MemoryPath): Null-Check and display error if MemoryPath not found
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
      ),
      // TODO(TheOneWithTheBraid): Layout- and Functionality-Update
      body: SnappingSheet(
        lockOverflowDrag: true,
        sheetAbove: null,
        grabbingHeight: 64,
        grabbing: Material(
          color: Theme.of(context).cardColor,
          elevation: 8,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: Container(
            alignment: Alignment.centerLeft,
            child: ListTile(
              title: const Text('Memory-Points'),
              trailing: IconButton(
                  onPressed: _expandBottom,
                  icon: const Icon(Icons.arrow_drop_down)),
              /*trailing: Switch(
                value: false,
                onChanged: null,
              ),*/
            ),
          ),
        ),
        sheetBelow: SnappingSheetContent(
            childScrollController: _listViewController,
            draggable: true,
            child: Material(
              color: Theme.of(context).cardColor,
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
          child: GestureDetector(
              child: _mapOrImage(),
              onTap: () => setState(() {
                    _mapDisplayed = !_mapDisplayed;
                  })),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, '/practice/${widget.memoryPath}'),
        label: const Text('Start Learning'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // TODO(TheOneWithTheBraid): Integration of Widgets and Clean up - Elements in draft commented underneath
      bottomNavigationBar: BottomAppBar(
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

  Widget _mapOrImage() {
    if (_mapDisplayed) {
      return StaticMapView(points: memoryPath!.memoryPoints!);
    } else {
      return MemoryPathImageDisplayer(
        memoryPath: memoryPath!,
      );
    }
  }

  void _expandBottom() {}
}

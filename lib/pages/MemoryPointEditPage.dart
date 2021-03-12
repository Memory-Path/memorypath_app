import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/src/MemoryPoint.dart';
import 'package:mobile/widgets/MemoryPointEditWidget.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

class MemoryPointEditPage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/edit\/(\d+)\/point\/(\d+)$');
  final int memoryPointId;
  final int memoryPathId;

  MemoryPointEditPage({this.memoryPointId, this.memoryPathId});

  @override
  _MemoryPointEditPageState createState() => _MemoryPointEditPageState();
}

class _MemoryPointEditPageState extends State<MemoryPointEditPage> {
  MemoryPathDb _memoryPathDbState;
  Box _memoryPathBox;

  @override
  void initState() {
    _memoryPathBox = databaseBox;
    _memoryPathDbState = _memoryPathBox.get(widget.memoryPathId);
    super.initState();
  }

  Future<void> onMemoryPointUpdate(MemoryPoint memoryPoint) async {
    _memoryPathDbState.memoryPoints[widget.memoryPointId] =
        memoryPoint.toMemoryPointDb();
    await _memoryPathBox.putAt(widget.memoryPathId, _memoryPathDbState);
    Navigator.of(context).pop();
  }

  Future<void> onMemoryPointDelete(MemoryPoint memoryPoint) async {
    _memoryPathDbState.memoryPoints.removeAt(widget.memoryPointId);
    await _memoryPathBox.putAt(widget.memoryPathId, _memoryPathDbState);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Memory-Point"),
        leading: IconButton(
            icon: Icon(Icons.close),
            tooltip: 'Discard',
            onPressed: () {
              if (_memoryPathDbState.memoryPoints[widget.memoryPointId].name ==
                  null) {
                _memoryPathDbState.memoryPoints.removeAt(widget.memoryPointId);
                _memoryPathBox.putAt(widget.memoryPathId, _memoryPathDbState);
              }
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 500,
          height: 700,
          child: MemoryPointEditWidget(
            memoryPathName: _memoryPathDbState.name,
            memoryPathTopic: _memoryPathDbState.topic,
            mapView: StaticMapView(
              emphasizePointId: widget.memoryPointId,
              points: _memoryPathDbState.memoryPoints,
            ),
            memoryPoint: MemoryPoint.fromDb(
                _memoryPathDbState.memoryPoints[widget.memoryPointId]),
            onMemoryPointUpdate: onMemoryPointUpdate,
            onMemoryPointDelete: onMemoryPointDelete,
          ),
        ),
      ),
    );
  }
}

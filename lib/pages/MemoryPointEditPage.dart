import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/src/MemoryPoint.dart';
import 'package:mobile/widgets/MemoryPointEditWidget.dart';

class MemoryPointEditPage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/memorypoint\/edit\/(\d+)$');
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

  void onMemoryPointUpdate(MemoryPoint memoryPoint) {
    _memoryPathDbState.memoryPoints[widget.memoryPointId] =
        memoryPoint.toMemoryPointDb();
    _memoryPathBox.putAt(widget.memoryPathId, _memoryPathDbState);
    Navigator.pop(context);
  }

  void onMemoryPointDelete(MemoryPoint memoryPoint) {
    _memoryPathDbState.memoryPoints.removeAt(widget.memoryPointId);
    _memoryPathBox.putAt(widget.memoryPathId, _memoryPathDbState);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Memory-Point"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 500,
          height: 700,
          child: MemoryPointEditWidget(
            memoryPathName: _memoryPathDbState.name,
            memoryPathTopic: _memoryPathDbState.topic,
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

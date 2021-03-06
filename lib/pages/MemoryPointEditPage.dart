import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
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
  MemoryPathDb _memoryPathState;
  Box _memoryPathBox;

  @override
  void initState() async {
    _memoryPathBox = Hive.box<MemoryPathDb>(HIVE_MEMORY_PATHS);
    _memoryPathState = _memoryPathBox.get(widget.memoryPathId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 500,
          height: 700,
          child: MemoryPointEditWidget(
            memoryPathName: _memoryPathState.name,
            memoryPathTopic: _memoryPathState.topic,
            memoryPointId: widget.memoryPointId,
          ),
        ),
      ),
    );
  }
}

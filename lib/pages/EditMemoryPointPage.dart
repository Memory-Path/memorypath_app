import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/EditMemoryPointWidget.dart';

/// deprecated class of the EditMemoryPointPage
/// just for overall functionality-reasons - will be replaced soon

class MemoryPointEditPage extends StatefulWidget {
  const MemoryPointEditPage({this.memoryPointId, this.memoryPathId});
  static final RegExp routeMatch = RegExp(r'^\/edit\/(\d+)\/point\/(\d+)$');
  final int memoryPointId;
  final int memoryPathId;


  @override
  _MemoryPointEditPageState createState() => _MemoryPointEditPageState();
}

class _MemoryPointEditPageState extends State<MemoryPointEditPage> {
  MemoryPathDb _memoryPathDbState;

  @override
  void initState() {
    _memoryPathDbState = databaseBox.get(widget.memoryPathId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memory-Point'),
        leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Discard',
            onPressed: () {
              if (_memoryPathDbState.memoryPoints[widget.memoryPointId].name ==
                  null) {
                _memoryPathDbState.memoryPoints.removeAt(widget.memoryPointId);
                databaseBox.putAt(widget.memoryPathId, _memoryPathDbState);
              }
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          child: EditMemoryPointWidget(
            memoryPoint:
                _memoryPathDbState.memoryPoints.elementAt(widget.memoryPointId),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/src/MemoryPath.dart';
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
  bool isLoading = true;
  MemoryPoint memoryPointState;
  MemoryPath memoryPathState;

  @override
  void initState() {
    //ToDo: Database Call
    MemoryPoint memoryPoint = MemoryPoint(
        id: 1,
        name: "The big old tree",
        image: null,
        question: "Hello? ",
        answer: "no ones there..",
        latlng: null);
    List<MemoryPoint> memoryPoints = List.empty(growable: true);
    memoryPoints.add(memoryPoint);
    MemoryPath memoryPath =
        MemoryPath(1, "The Way!", "Thermodynamics", memoryPoints);
    memoryPointState = memoryPoint;
    memoryPathState = memoryPath;

    isLoading = false;
    super.initState();
  }

  void deleteMemoryPoint(int memoryPointId) {
    isLoading = true;
    //ToDo: Database Deletion
    //Navigator.pop(context);
    print(memoryPointId);
  }

  void updateMemoryPoint(MemoryPoint memoryPoint) {
    isLoading = true;
    //ToDo: Database Update
    //Navigator.pop(context);
    print(memoryPoint.answer);
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
            memoryPathName: memoryPathState.name,
            memoryPathTopic: memoryPathState.topic,
            memoryPoint: memoryPointState,
            onMemoryPointUpdate: updateMemoryPoint,
            onMemoryPointDelete: deleteMemoryPoint,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:memorypath_db_api/src/MemoryPath.dart';
import 'package:mobile/main.dart';

class PracticePage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/practice\/(\d+)$');
  final int memoryPath;

  const PracticePage({Key key, this.memoryPath}) : super(key: key);
  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  MemoryPathDb memoryPath;
  bool showAnswer = false;

  @override
  void initState() {
    memoryPath = databaseBox.get(widget.memoryPath);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      itemBuilder: (c, i) {
        final point = memoryPath.memoryPoints[i];
        return ListView(
          children: [
            ListTile(
              title: Text(point.name ?? "unknown"),
            ),
            ListTile(
              title: Text(point.question ?? "unknown"),
            ),
            showAnswer
                ? ListTile(
                    title: Text(point.answer ?? "unknown"),
                  )
                : OutlinedButton(
                    onPressed: () => setState(() => showAnswer = true),
                    child: Text("Show answer")),
          ],
          shrinkWrap: true,
        );
      },
      itemCount: memoryPath.memoryPoints.length,
    ));
  }
}

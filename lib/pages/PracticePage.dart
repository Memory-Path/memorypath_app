import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
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

  int _currentPoint = 0;
  bool _reverse = false;

  @override
  void initState() {
    memoryPath = databaseBox.get(widget.memoryPath);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Practice Memory-Path ${memoryPath.name}'),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 300),
                      reverse: _reverse,
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return SharedAxisTransition(
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.vertical);
                      },
                      layoutBuilder:
                          PageTransitionSwitcher.defaultLayoutBuilder,
                      child: _currentPoint < memoryPath.memoryPoints.length
                          ? new _PointView(
                              key: GlobalKey(),
                              point: memoryPath.memoryPoints[_currentPoint])
                          : Center(
                              child: Text('Summary'),
                            ),
                    ),
                  ),
                ],
              ),
              _RouteSidebar(
                currentPoint: _currentPoint,
                points: memoryPath.memoryPoints,
                onPointSelected: (index) {
                  setState(() {
                    _reverse = index < _currentPoint;
                    _currentPoint = index;
                  });
                },
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _currentPoint < memoryPath.memoryPoints.length
            ? FloatingActionButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _reverse = false;
                    _currentPoint++;
                  });
                },
              )
            : null);
  }
}

class _RouteSidebar extends StatelessWidget {
  @required
  final List<MemoryPointDb> points;
  @required
  final int currentPoint;
  @required
  final Function(int) onPointSelected;

  const _RouteSidebar(
      {Key key, this.currentPoint, this.onPointSelected, this.points})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      child: Card(
        color: Theme.of(context).cardColor.withAlpha(64),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return IconButton(
                color: index == currentPoint
                    ? Theme.of(context).primaryColor
                    : null,
                tooltip: index >= points.length
                    ? 'Summary'
                    : 'Point ${index + 1}: ${points[index].name ?? 'unknown'}',
                icon: index >= points.length
                    ? Icon(Icons.format_list_bulleted)
                    : Icon(Icons.lightbulb),
                onPressed: () {
                  if (currentPoint != index) onPointSelected(index);
                });
          },
          itemCount: points.length + 1,
          separatorBuilder: (context, index) {
            return Center(
              child: Container(
                width: 4,
                height:
                    (MediaQuery.of(context).size.height / 2) / points.length,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PointView extends StatefulWidget {
  final MemoryPointDb point;

  const _PointView({Key key, this.point}) : super(key: key);

  @override
  __PointViewState createState() => __PointViewState();
}

class __PointViewState extends State<_PointView> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: 768),
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.point.name ?? "unknown",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text(widget.point.question ?? "unknown"),
              ),
              PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                        child: child,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical);
                  },
                  layoutBuilder: PageTransitionSwitcher.defaultLayoutBuilder,
                  child: _showAnswer
                      ? ListTile(
                          leading: Icon(Icons.edit_location),
                          title: Text(widget.point.answer ?? "unknown"),
                        )
                      : ButtonBar(
                          children: [
                            OutlinedButton(
                                onPressed: () =>
                                    setState(() => _showAnswer = true),
                                child: Text("Show answer")),
                          ],
                        )),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _PointView oldWidget) {
    _showAnswer = false;
    super.didUpdateWidget(oldWidget);
  }
}

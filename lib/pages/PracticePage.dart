import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/widgets/FlippingCard.dart';
import 'package:mobile/widgets/ResponsiveCard.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key, this.memoryPath}) : super(key: key);
  static final RegExp routeMatch = RegExp(r'^\/practice\/(\d+)$');
  final int? memoryPath;

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  MemoryPathDb? memoryPath;

  int _currentPoint = 0;
  bool _reverse = false;

  final Map<int, bool> _pointsAnswered = <int, bool>{};

  @override
  void initState() {
    memoryPath = databaseBox.get(widget.memoryPath);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? percentage;
    if (_pointsAnswered.isNotEmpty) {
      percentage = 0;
      _pointsAnswered.forEach((int key, bool value) {
        if (value) {
          percentage = percentage! + 1;
        }
      });
      percentage = percentage! / _pointsAnswered.length;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Practice Memory-Path ${memoryPath!.name}'),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: '${HeroTags.MapView}${memoryPath!.key}',
                    child: StaticMapView(
                      points: memoryPath!.memoryPoints,
                      emphasizePointId: _currentPoint,
                      //key: GlobalKey(),
                    ),
                  ), // TODO(MemoryPath): dirty code,
                  Expanded(
                    child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 300),
                        reverse: _reverse,
                        transitionBuilder: (Widget child,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return SharedAxisTransition(
                              child: child,
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.vertical);
                        },
                        layoutBuilder:
                            PageTransitionSwitcher.defaultLayoutBuilder,
                        child: _currentPoint < memoryPath!.memoryPoints.length
                            ? _PointView(
                                key: GlobalKey(),
                                point: memoryPath!.memoryPoints[_currentPoint],
                                onAnswered: (bool correct) {
                                  _pointsAnswered[_currentPoint] = correct;
                                  setState(() {
                                    _currentPoint++;
                                  });
                                },
                              )
                            : SummaryCard(
                                percentage: percentage,
                              )),
                  ),
                ],
              ),
              _RouteSidebar(
                currentPoint: _currentPoint,
                points: memoryPath!.memoryPoints,
                onPointSelected: (int index) {
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
        floatingActionButton: _currentPoint < memoryPath!.memoryPoints.length
            ? FloatingActionButton(
                child: const Icon(Icons.arrow_forward),
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

class SummaryCard extends StatelessWidget {
  const SummaryCard({Key? key, this.percentage}) : super(key: key);
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: percentage != null
          ? ListTile(
              leading: const Icon(Icons.pie_chart),
              title: Text('${(percentage! * 100).round()} % correct'),
            )
          : const ListTile(
              leading: Icon(Icons.info),
              title: Text('Try to answer some questions...'),
            ),
    );
  }
}

class _RouteSidebar extends StatelessWidget {
  const _RouteSidebar(
      {Key? key, this.currentPoint, this.onPointSelected, this.points})
      : super(key: key);
  @required
  final List<MemoryPointDb>? points;
  @required
  final int? currentPoint;
  @required
  final Function(int)? onPointSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      child: Card(
        color: Theme.of(context).cardColor.withAlpha(64),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return IconButton(
                color: index == currentPoint
                    ? Theme.of(context).primaryColor
                    : null,
                tooltip: index >= points!.length
                    ? 'Summary'
                    : 'Point ${index + 1}: ${points![index].name ?? 'unknown'}',
                icon: index >= points!.length
                    ? const Icon(Icons.format_list_bulleted)
                    : const Icon(Icons.lightbulb),
                onPressed: () {
                  if (currentPoint != index) {
                    onPointSelected!(index);
                  }
                });
          },
          itemCount: points!.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                width: 4,
                height:
                    (MediaQuery.of(context).size.height / 2) / points!.length,
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
  const _PointView({Key? key, this.point, this.onAnswered}) : super(key: key);
  final MemoryPointDb? point;
  final Function(bool correct)? onAnswered;

  @override
  __PointViewState createState() => __PointViewState();
}

class __PointViewState extends State<_PointView> {
  @override
  Widget build(BuildContext context) {
    return FlippingCard(
      height: MediaQuery.of(context).size.height / 2,
      front: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.point!.name ?? 'unknown',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: Text(widget.point!.question ?? 'unknown'),
          ),
          Expanded(child: Container()),
          ListTile(
            title: Text(
              'Tap to show answer.',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      rear: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              (widget.point!.name ?? 'unknown') +
                  ' - ' +
                  (widget.point!.question ?? 'unknown'),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_location),
            title: Text(widget.point!.answer ?? 'unknown'),
          ),
          Expanded(child: Container()),
          const Divider(),
          const ListTile(
            title: Text(
              'Did you know the correct answer?',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ButtonBar(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => widget.onAnswered!(true),
                  label: const Text('Yes')),
              TextButton.icon(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () => widget.onAnswered!(false),
                  label: const Text('No')),
            ],
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

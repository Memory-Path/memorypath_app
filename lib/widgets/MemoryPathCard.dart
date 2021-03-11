import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/PracticePage.dart';
import 'package:mobile/widgets/CenterProgress.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

class MemoryPathCard extends StatefulWidget {
  final MemoryPathDb memoryPath;

  const MemoryPathCard({Key key, this.memoryPath}) : super(key: key);

  @override
  _MemoryPathCardState createState() => _MemoryPathCardState();
}

class _MemoryPathCardState extends State<MemoryPathCard> {
  MBDirections directions;
  bool loadingDirections = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 393),
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OpenContainer(
          closedColor: Theme.of(context).cardColor,
          closedShape: Theme.of(context).cardTheme.shape,
          closedBuilder: (c, f) => ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  widget.memoryPath.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                trailing: IconButton(
                    tooltip: 'Edit path',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/editPath/${widget.memoryPath.key}');
                    }),
              ),
              Hero(
                tag: StaticMapView,
                child: StaticMapView(
                  points: widget.memoryPath.memoryPoints,
                  onDirectionsUpdate: setDirections,
                ),
              ),
              !loadingDirections
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.height),
                          title: Text(
                              'Total distance: ${(directions.distance / 1000).round()} km'),
                        ),
                        ListTile(
                          leading: Icon(Icons.timer),
                          title: Text(
                              'Walking time: ${directions.duration.inMinutes} min'),
                        ),
                      ],
                    )
                  : CenterProgress(),
              /*ButtonBar(
                children: [
                  Stack(
                    fit: StackFit.passthrough,
                    children: [
                      OutlinedButton.icon(
                          icon: Icon(Icons.fitness_center),
                          label: Text("Practice")),
                    ],
                  ),
                ],
              )*/
            ],
          ),
          routeSettings:
              RouteSettings(name: '/practice/${widget.memoryPath.key}'),
          openBuilder: (c, f) => PracticePage(
            memoryPath: widget.memoryPath.key,
          ),
          openColor: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  void setDirections(MBDirections newDirections) {
    setState(() {
      directions = newDirections;
      loadingDirections = false;
    });
  }
}

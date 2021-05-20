import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/PracticePage.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/widgets/CenterProgress.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

class MemoryPathCard extends StatefulWidget {
  const MemoryPathCard({Key key, this.memoryPath}) : super(key: key);
  final MemoryPathDb memoryPath;

  @override
  _MemoryPathCardState createState() => _MemoryPathCardState();
}

class _MemoryPathCardState extends State<MemoryPathCard> {
  MBDirections directions;
  bool loadingDirections = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 393),
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: OpenContainer(
            closedColor: Theme.of(context).cardColor,
            closedShape: Theme.of(context).cardTheme.shape,
            closedBuilder: (BuildContext c, VoidCallback f) => ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text(
                    widget.memoryPath.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  trailing: IconButton(
                      tooltip: 'Edit path',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/editPath/${widget.memoryPath.key}');
                      }),
                ),
                Hero(
                  tag: '${HeroTags.MapView}${widget.memoryPath.key}',
                  child: StaticMapView(
                    points: widget.memoryPath.memoryPoints,
                    onDirectionsUpdate: setDirections,
                  ),
                ),
                if (!loadingDirections)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.height),
                        title: Text(
                            'Total distance: ${(directions.distance / 1000).round()} km'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.timer),
                        title: Text(
                            'Walking time: ${directions.duration.inMinutes} min'),
                      ),
                    ],
                  )
                else
                  const CenterProgress(),
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
            openBuilder: (BuildContext c, VoidCallback f) => PracticePage(
              memoryPath: widget.memoryPath.key as int,
            ),
            openColor: Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MemoryPathCard oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  void setDirections(MBDirections newDirections) {
    setState(() {
      directions = newDirections;
      loadingDirections = false;
    });
  }
}

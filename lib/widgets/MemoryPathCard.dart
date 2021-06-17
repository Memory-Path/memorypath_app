import 'package:animations/animations.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/pages/PracticePage.dart';

class MemoryPathCard extends StatefulWidget {
  const MemoryPathCard({Key? key, required this.memoryPath}) : super(key: key);
  final MemoryPathDb memoryPath;

  @override
  _MemoryPathCardState createState() => _MemoryPathCardState();
}

class _MemoryPathCardState extends State<MemoryPathCard> {
  //late MBDirections directions;
  Future<FilePickerCross>? _imageStateFuture;
  //bool loadingDirections = true;

  @override
  void initState() {
    if (widget.memoryPath.memoryPoints!.isNotEmpty) {
      if (widget.memoryPath.memoryPoints!.first.image != null) {
        _imageStateFuture = FilePickerCross.fromInternalPath(
            path: widget.memoryPath.memoryPoints!.first.image!);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: 250, maxWidth: MediaQuery.of(context).size.width / 2),
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: OpenContainer(
            closedColor: Theme.of(context).cardColor,
            closedShape: Theme.of(context).cardTheme.shape!,
            closedBuilder: (BuildContext c, VoidCallback f) => ListView(
              shrinkWrap: true,
              children: <Widget>[
                // TODO(MemoryPath): Unfinished MemoryPath-Indicator
                if (_imageStateFuture != null)
                  FutureBuilder<FilePickerCross>(
                      future: _imageStateFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<FilePickerCross> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    MemoryImage(snapshot.data!.toUint8List()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:
                                memoryPathUnfinishedWidget(widget.memoryPath),
                          );
                        } else {
                          return Container(
                              child: const Center(
                                  child: CircularProgressIndicator()));
                        }
                      })
                else
                  // TODO(Lanna): Fill in Blur-Image
                  Container(
                    color: Colors.amber,
                    height: 150,
                    child: memoryPathUnfinishedWidget(widget.memoryPath),
                  ),
                ListTile(
                  title: Text(
                    widget.memoryPath.name!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(widget.memoryPath.topic!),
                  // TODO(MemoryPath): Add Card-Number and Location
                  // trailing: IconButton(
                  //     tooltip: 'Edit path',
                  //     icon: const Icon(Icons.edit),
                  //     onPressed: () {
                  //       Navigator.of(context)
                  //           .pushNamed('/editPath/${widget.memoryPath.key}');
                  //     }),
                ),

                // Hero(
                //   tag: '${HeroTags.MapView}${widget.memoryPath.key}',
                //   child: StaticMapView(
                //     points: widget.memoryPath.memoryPoints!,
                //     onDirectionsUpdate: setDirections,
                //   ),
                // ),
                // if (!loadingDirections)
                //   Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: <Widget>[
                //       ListTile(
                //         leading: const Icon(Icons.height),
                //         title: Text(
                //             'Total distance: ${(directions.distance / 1000).round()} km'),
                //       ),
                //       ListTile(
                //         leading: const Icon(Icons.timer),
                //         title: Text(
                //             'Walking time: ${directions.duration.inMinutes} min'),
                //       ),
                //     ],
                //   )
                // else
                //   const CenterProgress(),
              ],
            ),
            routeSettings:
                RouteSettings(name: '/practice/${widget.memoryPath.key}'),
            openBuilder: (BuildContext c, VoidCallback f) => PracticePage(
              memoryPath: widget.memoryPath.key as int?,
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

  // void setDirections(MBDirections newDirections) {
  //   setState(() {
  //     directions = newDirections;
  //     loadingDirections = false;
  //   });
  // }

  Widget? memoryPathUnfinishedWidget(MemoryPathDb memoryPathDb) {
    bool unfinished = false;
    for (final MemoryPointDb element in memoryPathDb.memoryPoints!) {
      if (element.image == null || element.lat == null) {
        unfinished = true;
      }
    }
    if (unfinished) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 2,
                color: Colors.grey[700]!,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(64))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.access_time,
              size: 32,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }
  }
}

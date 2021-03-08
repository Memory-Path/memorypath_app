import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

class MemoryPathCard extends StatelessWidget {
  final MemoryPathDb memoryPath;

  const MemoryPathCard({Key key, this.memoryPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 393),
      child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: Card(
            child: Column(
              children: [
                Text(
                  memoryPath.name,
                ),
                StaticMapView(points: memoryPath.memoryPoints),
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class StaticMapView extends StatefulWidget {
  final List<MemoryPointDb> points;

  const StaticMapView({Key key, this.points = const []}) : super(key: key);
  @override
  _StaticMapViewState createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        /*onHorizontalDragStart: (d) {},
        onVerticalDragStart: (d) {},*/
        onDoubleTap: () {},
        onPanStart: (d) {},
        child: MapView(
          showLocationButton: false,
          waypoints: mp2m(widget.points),
        ),
      ),
      height: MediaQuery.of(context).size.height / 4,
    );
  }

  List<Marker> mp2m(List<MemoryPointDb> points) {
    return points
        .map((e) => Marker(
            point: LatLng(e.lat, e.long),
            builder: (context) => IconButton(
                  icon: Icon(
                    Icons.location_pin,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                  tooltip: e.name,
                )))
        .toList();
  }
}

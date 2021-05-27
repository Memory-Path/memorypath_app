import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class StaticMapView extends StatefulWidget {
  const StaticMapView(
      {Key? key,
      this.points = const <MemoryPointDb>[],
      this.emphasizePointId,
      this.onDirectionsUpdate})
      : super(key: key);

  /// all points to be displayed
  final List<MemoryPointDb> points;

  /// a point to be emphasized
  final int? emphasizePointId;

  final MBDirectionsCallback? onDirectionsUpdate;

  @override
  _StaticMapViewState createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  final MapViewController _controller = MapViewController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          MapView(
            controller: _controller,
            showLocationButton: false,
            waypoints: mp2m(widget.points),
            onDirectionsUpdate:
                widget.onDirectionsUpdate ?? (MBDirections d) {},
          ),
          Container(
            color: Colors.transparent,
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height / 4,
    );
  }

  @override
  void didUpdateWidget(StaticMapView oldWidget) {
    if (oldWidget.points != widget.points)
      _controller.waypoints = mp2m(widget.points);
    super.didUpdateWidget(oldWidget);
  }

  List<Marker> mp2m(List<MemoryPointDb> points) {
    final List<Marker> markers = <Marker>[];
    for (int i = 0; i < points.length; i++) {
      final MemoryPointDb e = points[i];
      markers.add(Marker(
          point: LatLng(e.lat, e.long),
          builder: (BuildContext context) => IconButton(
                icon: Icon(
                  Icons.location_pin,
                  color: (widget.emphasizePointId == i)
                      ? Colors.deepOrange
                      : Theme.of(context).primaryColor,
                ),
                onPressed: () {},
                tooltip: e.name,
              )));
    }
    return markers;
  }
}

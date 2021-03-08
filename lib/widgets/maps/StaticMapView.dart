import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class StaticMapView extends StatefulWidget {
  /// all points to be displayed
  final List<MemoryPointDb> points;

  /// a point to be emphasized
  final int emphasizePointId;

  final MBDirectionsCallback onDirectionsUpdate;

  const StaticMapView(
      {Key key,
      this.points = const [],
      this.emphasizePointId,
      this.onDirectionsUpdate})
      : super(key: key);
  @override
  _StaticMapViewState createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          MapView(
            showLocationButton: false,
            waypoints: mp2m(widget.points),
            onDirectionsUpdate: widget?.onDirectionsUpdate ?? (d) {},
          ),
          Container(
            color: Colors.transparent,
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height / 4,
    );
  }

  List<Marker> mp2m(List<MemoryPointDb> points) {
    List<Marker> markers = [];
    for (int i = 0; i < points.length; i++) {
      final e = points[i];
      markers.add(Marker(
          point: LatLng(e.lat, e.long),
          builder: (context) => IconButton(
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

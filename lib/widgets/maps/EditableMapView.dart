import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_api/map_api.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class EditableMapView extends StatefulWidget {
  final List<MemoryPointDb> initialMemoryPoints;
  final MemoryPointsUpdatedCallback onChange;

  const EditableMapView(
      {Key key, this.initialMemoryPoints = const [], this.onChange})
      : super(key: key);
  @override
  _EditableMapViewState createState() => _EditableMapViewState();
}

class _EditableMapViewState extends State<EditableMapView> {
  MapViewController _controller = MapViewController();

  List<MemoryPointDb> points = [];

  TextEditingController _newPOIController = TextEditingController();

  @override
  void initState() {
    points.addAll(widget.initialMemoryPoints);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapView(
        controller: _controller,
        onTap: addMemoryPoint,
        waypoints: mp2m(points),
      ),
      height: MediaQuery.of(context).size.height / 4,
    );
  }

  void addMemoryPoint(LatLng coordinates) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add new Memory-Point'),
              content: TextField(
                controller: _newPOIController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Memory-Point name'),
              ),
              actions: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        points.add(MemoryPointDb(
                            name: _newPOIController.text,
                            lat: coordinates.latitude,
                            long: coordinates.longitude));
                        _newPOIController.text = '';
                        _controller.waypoints = mp2m(points);
                      });
                      if (widget.onChange != null) widget.onChange(points);
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'))
              ],
            ));
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

typedef void MemoryPointsUpdatedCallback(List<MemoryPointDb> memoryPoints);

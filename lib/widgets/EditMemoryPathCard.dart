import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/widgets/maps/EditableMapView.dart';

class EditMemoryPathCard extends StatefulWidget {
  final MemoryPathCreatedCallback onCreated;
  final MemoryPathDb path;

  const EditMemoryPathCard({Key key, @required this.onCreated, this.path})
      : super(key: key);
  @override
  _EditMemoryPathCardState createState() => _EditMemoryPathCardState();
}

class _EditMemoryPathCardState extends State<EditMemoryPathCard> {
  TextEditingController _newMemoryPathController = TextEditingController();
  TextEditingController _topicController = TextEditingController();

  List<MemoryPointDb> _points = [];

  @override
  void initState() {
    if (widget.path != null) {
      _newMemoryPathController.text = widget.path.name;
      _topicController.text = widget.path.topic;
      _points = widget.path.memoryPoints;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: 768),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    controller: _newMemoryPathController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Path name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: EditableMapView(
                      initialMemoryPoints: _points,
                      onChange: (memoryPoints) {
                        setState(() {
                          _points = memoryPoints;

                          if (widget.path != null)
                            widget.path.memoryPoints = _points;
                        });
                      },
                    ),
                  ),
                  _points.isNotEmpty
                      ? ListTile(
                          leading: Icon(Icons.info),
                          title: widget.path != null
                              ? Text('Tap on list item to edit point details')
                              : Text(
                                  'Save your path and come back to edit point details'),
                        )
                      : ListTile(
                          leading: Icon(Icons.touch_app),
                          title: Text('Tap on map to add Memory-Points'),
                        ),
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: (_points.length * 48).toDouble()),
                    child: ReorderableListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) => ListTile(
                              key: ValueKey(_points[i]),
                              onTap: () {
                                if (widget.path != null)
                                  Navigator.of(context).pushNamed(
                                      '/edit/${widget.path.key}/point/$i');
                              },
                              leading: Icon(Icons.lightbulb),
                              title: Text(_points[i].name),
                            ),
                        itemCount: _points.length,
                        onReorder: (oldIndex, newIndex) {
                          final point = _points[oldIndex];

                          _points.insert(newIndex, point);
                          _points.removeAt(oldIndex);
                          if (widget.path != null)
                            widget.path.memoryPoints = _points;
                          setState(() {});
                        }),
                  ),
                  TextField(
                    autofocus: true,
                    controller: _topicController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Topic'),
                  ),
                  ButtonBar(
                    children: [
                      OutlinedButton.icon(
                        icon: Hero(
                            tag: HeroTags.AddPathIcon,
                            child: Icon(Icons.check)),
                        onPressed: () {
                          if (_newMemoryPathController.text.trim() == '' ||
                              _topicController.text.trim() == '' ||
                              _points.length < 2) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Please fill in all fields and add at least 2 memory points.')));
                            return;
                          }
                          if (widget.path != null) {
                            widget.path.name = _newMemoryPathController.text;
                            widget.path.topic = _topicController.text;
                            //widget.path.memoryPoints = _points;
                            Navigator.of(context).pop(); // TODO: that's dirty
                          } else
                            widget.onCreated(MemoryPathDb(
                                name: _newMemoryPathController.text,
                                topic: _topicController.text,
                                memoryPoints: _points));
                        },
                        label: Text('Save Memory-Path'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef void MemoryPathCreatedCallback(MemoryPathDb memoryPath);

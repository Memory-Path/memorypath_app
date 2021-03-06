import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/widgets/maps/EditableMapView.dart';

class CreateMemoryPathCard extends StatefulWidget {
  final MemoryPathCreatedCallback onCreated;

  const CreateMemoryPathCard({Key key, @required this.onCreated})
      : super(key: key);
  @override
  _CreateMemoryPathCardState createState() => _CreateMemoryPathCardState();
}

class _CreateMemoryPathCardState extends State<CreateMemoryPathCard> {
  TextEditingController _newMemoryPathController = TextEditingController();
  TextEditingController _topicController = TextEditingController();

  List<MemoryPointDb> points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: 393),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Column(
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
                      onChange: (memoryPoints) {
                        points = memoryPoints;
                      },
                    ),
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
                            tag: HeroTags.AddPathIcon, child: Icon(Icons.add)),
                        onPressed: () {
                          widget.onCreated(
                              // TODO: fix
                              MemoryPathDb(
                                  name: _newMemoryPathController.text,
                                  topic: _topicController.text,
                                  memoryPoints: points));
                        },
                        label: Text('Create Memory-Path'),
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

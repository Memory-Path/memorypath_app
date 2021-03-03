import 'package:flutter/material.dart';
import 'package:map_api/map_api.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/src/MemoryPath.dart';
import 'package:mobile/widgets/maps/EditableMapView.dart';

class CreateMemoryPathCard extends StatefulWidget {
  final MemoryPathCreatedCallback onCreated;

  const CreateMemoryPathCard({Key key, this.onCreated}) : super(key: key);
  @override
  _CreateMemoryPathCardState createState() => _CreateMemoryPathCardState();
}

class _CreateMemoryPathCardState extends State<CreateMemoryPathCard> {
  TextEditingController _newMemoryPathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 393),
      child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      onChange: (memoryPoints) {},
                    ),
                  ),
                  ButtonBar(
                    children: [
                      Hero(
                        tag: HeroTags.AddPathIcon,
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                          label: Text('Create Memory-Path'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

typedef void MemoryPathCreatedCallback(MemoryPath memoryPath);

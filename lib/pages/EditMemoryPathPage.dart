import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/EditMemoryPathCard.dart';

class EditMemoryPathPage extends StatefulWidget {
  const EditMemoryPathPage({Key key, this.path, this.onCreated})
      : super(key: key);
  static final RegExp routeMatch = RegExp(r'^\/(createPath|editPath\/(\d+))');

  final MemoryPathCreatedCallback onCreated;
  final int path;
  @override
  _EditMemoryPathPageState createState() => _EditMemoryPathPageState();
}

class _EditMemoryPathPageState extends State<EditMemoryPathPage> {
  MemoryPathDb path;

  @override
  void initState() {
    if (widget.path != null) {
      path = databaseBox.get(widget.path);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((path != null ? 'Edit' : 'Create') + ' Memory-Path'),
        leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Discard',
            onPressed: backToHome),
        actions: <Widget>[
          if (widget.path != null)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                showModal<Null>(
                    context: context,
                    builder: (BuildContext c) {
                      return AlertDialog(
                        title: Text('Are your sure to delete ${path.name}?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                databaseBox.delete(path.key);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'))
                        ],
                      );
                    });
              },
              tooltip: 'Delete Memory-Path...',
            )
        ],
      ),
      body: EditMemoryPathCard(onCreated: createPath, path: path),
    );
  }

  Future<void> createPath(MemoryPathDb memoryPath) async {
    final int id = await databaseBox.add(memoryPath);
    print('New path\'s id: $id');
    backToHome();
  }

  void backToHome() {
    if (widget.onCreated != null) {
      Navigator.of(context).pop();
    } else
      Navigator.of(context).popAndPushNamed('/home');
  }
}

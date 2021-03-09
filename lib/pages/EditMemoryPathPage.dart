import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:memorypath_db_api/src/MemoryPath.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/EditMemoryPathCard.dart';

class EditMemoryPathPage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/(createPath|editPath\/(\d+))');

  final MemoryPathCreatedCallback onCreated;
  final int path;
  const EditMemoryPathPage({Key key, this.path, this.onCreated})
      : super(key: key);
  @override
  _EditMemoryPathPageState createState() => _EditMemoryPathPageState();
}

class _EditMemoryPathPageState extends State<EditMemoryPathPage> {
  MemoryPathDb path;

  @override
  void initState() {
    if (widget.path != null) path = databaseBox.get(widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((path != null ? 'Edit' : 'Create') + ' Memory-Path'),
        leading: IconButton(
            icon: Icon(Icons.close), tooltip: 'Discard', onPressed: backToHome),
      ),
      body: EditMemoryPathCard(onCreated: createPath, path: path),
    );
  }

  Future<void> createPath(MemoryPathDb memoryPath) async {
    final id = await databaseBox.add(memoryPath);
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

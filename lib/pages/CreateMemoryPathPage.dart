import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:memorypath_db_api/src/MemoryPath.dart';
import 'package:mobile/main.dart';
import 'package:mobile/widgets/CreateMemoryPathCard.dart';

class CreateMemoryPathPage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/createPath');
  final MemoryPathCreatedCallback onCreated;

  const CreateMemoryPathPage({Key key, this.onCreated}) : super(key: key);
  @override
  _CreateMemoryPathPageState createState() => _CreateMemoryPathPageState();
}

class _CreateMemoryPathPageState extends State<CreateMemoryPathPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Memory-Path'),
        leading: IconButton(
            icon: Icon(Icons.close), tooltip: 'Discard', onPressed: backToHome),
      ),
      body: CreateMemoryPathCard(
        onCreated: createPath,
      ),
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

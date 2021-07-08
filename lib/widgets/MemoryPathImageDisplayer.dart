import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/globals.dart';

/// Widget to display the Image representing the MemoryPath - checks whether MemoryPath is "valid"
class MemoryPathImageDisplayer extends StatefulWidget {
  const MemoryPathImageDisplayer({
    Key? key,
    required this.memoryPath,
  }) : super(key: key);
  final MemoryPathDb memoryPath;

  @override
  _MemoryPathImageDisplayerState createState() =>
      _MemoryPathImageDisplayerState();
}

class _MemoryPathImageDisplayerState extends State<MemoryPathImageDisplayer> {
  Future<FilePickerCross>? _imageStateFuture;

  @override
  void initState() {
    if (widget.memoryPath.memoryPoints!.isNotEmpty) {
      if (widget.memoryPath.memoryPoints!.first.image != null) {
        _imageStateFuture = FilePickerCross.fromInternalPath(
            path: widget.memoryPath.memoryPoints!.first.image!);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (_imageStateFuture != null) {
          return FutureBuilder<FilePickerCross>(
              future: _imageStateFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<FilePickerCross> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(snapshot.data!.toUint8List()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _memoryPathUnfinishedWidget(
                        widget.memoryPath, constraints),
                  );
                } else {
                  return Container(
                      child: const Center(child: CircularProgressIndicator()));
                }
              });
        } else
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(defaultImagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: _memoryPathUnfinishedWidget(widget.memoryPath, constraints),
          );
      },
    );
  }

  //checks if MemoryPath is valid and if not returns a centered Clock-Icon
  Widget? _memoryPathUnfinishedWidget(
      MemoryPathDb memoryPathDb, BoxConstraints constraints) {
    bool unfinished = false;
    for (final MemoryPointDb element in memoryPathDb.memoryPoints!) {
      if (element.image == null || element.lat == null) {
        unfinished = true;
      }
    }
    if (unfinished) {
      return Align(
        alignment: Alignment.center,
        child: Opacity(
          opacity: 0.75,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  width: 4,
                  color: Colors.grey[700]!,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(constraints.maxWidth / 7))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.access_time,
                size: constraints.maxWidth / 7,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      );
    }
  }
}

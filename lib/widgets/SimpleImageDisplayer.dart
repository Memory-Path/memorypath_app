import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:mobile/globals.dart';

/// Widget to display an Image by InternalPath - if Path is null the default Image is taken
class SimpleImageDisplayer extends StatefulWidget {
  const SimpleImageDisplayer({Key? key, required this.path}) : super(key: key);
  final String? path;

  @override
  _SimpleImageDisplayerState createState() => _SimpleImageDisplayerState();
}

class _SimpleImageDisplayerState extends State<SimpleImageDisplayer> {
  Future<FilePickerCross>? _imageStateFuture;

  @override
  void initState() {
    if (widget.path != null) {
      _imageStateFuture = FilePickerCross.fromInternalPath(path: widget.path!);
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
                );
              } else {
                return Container(
                    child: const Center(child: CircularProgressIndicator()));
              }
            });
      } else {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(defaultImagePath),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    });
  }
}

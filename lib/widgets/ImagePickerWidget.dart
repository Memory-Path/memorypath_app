import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

typedef OnUpdateImageCallback = void Function(String image);

///Configuration for the Storage-Path, where images, that are used in the App, are stored.
const String STORAGE_PATH = 'assets/images/';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({this.imagePath, this.onImageChanged});

  ///Configuration of the default image, that is displayed, when no image is set yet
  static const String defaultImage='assets/images/blurry_background.jpg';

  ///The Image of a MemoryPoint - can be null
  final String imagePath;

  /// Callback for [EditMemoryPointWidget]
  final OnUpdateImageCallback onImageChanged;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  ///image, that is not yet loaded
  Future<FilePickerCross> _imageStateFuture;

  ///loaded image
  FilePickerCross _imageState;

  ///actual imagePath, that can be modified by the User
  String _imagePathState;

  @override
  void initState() {
    ///set the actual values passed by the constructor
    _imagePathState = widget.imagePath;
    if (_imagePathState != null) {
      _imageStateFuture =
          FilePickerCross.fromInternalPath(path: _imagePathState);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO(MemoryPath): Make size of Elements responsive,
    return GestureDetector(
        onTap: () async {
          _showPicker(context);
        },

        ///3 Cases:
        ///ImagePath is not set -> defaultImage
        ///ImagePath is set already but Image not loaded -> Loading Indicator
        ///ImagePath is set and Image loaded -> display Image
        child: _imagePathState != null
            // TODO(MemoryPath): What to do with empty Path? "|| _imagePathState.isEmpty",
            ? _imageState == null
                ? FutureBuilder<FilePickerCross>(
                    future: _imageStateFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<FilePickerCross> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(snapshot.data.toUint8List()),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey[700],
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(64))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }
                    })
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_imageState.toUint8List()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              width: 2,
                              color: Colors.grey[700],
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(64))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  )
            : Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePickerWidget.defaultImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(
                          width: 2,
                          color: Colors.grey[700],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(64))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ));
  }

  // TODO(MemoryPath): Delete unused Images from Storage,
  ///Handling of the process of taking an Image via Camera
  Future<void> _imgFromCamera() async {
    Navigator.push(
        context,
        MaterialPageRoute<CameraCamera>(
            builder: (_) => CameraCamera(
                  onFile: (File file) async {
                    final FilePickerCross imageData =
                        FilePickerCross(await file.readAsBytes());
                    final String path =
                        STORAGE_PATH + DateTime.now().toString() + '.png';
                    await imageData.saveToPath(path: path);
                    Navigator.pop(context);
                    setState(() {
                      _imagePathState = path;
                      _imageState = imageData;
                      widget.onImageChanged(_imagePathState);
                    });
                  },
                )));
  }

  ///Handling the Process of selecting an Image from User-Storage
  Future<void> _imgFromStorage() async {
    final FilePickerCross image =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    final String path = STORAGE_PATH + DateTime.now().toString() + '.png';
    image.saveToPath(path: path);
    setState(() {
      _imageState = image;
      _imagePathState = path;
      widget.onImageChanged(_imagePathState);
    });
  }

  ///Handling the kind of Selection of an Image
  ///for mobile devices: displays menu to select from Gallery or take new Picture from Camera
  ///for desktop/web: only Picture from Storage
  Future<void> _showPicker(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      await _imgFromStorage();
    } else {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Photo Library'),
                        onTap: () async {
                          await _imgFromStorage();
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _imgFromCamera();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}

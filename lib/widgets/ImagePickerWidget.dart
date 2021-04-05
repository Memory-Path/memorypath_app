import 'package:camera_camera/camera_camera.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

typedef void OnUpdateImageCallback(String image);

const String STORAGE_PATH = "assets/images/";

class ImagePickerWidget extends StatefulWidget {
  //config:

  final String defaultImage = "assets/images/blurry_background.jpg";

  // image that is lately filled by Gallery or Camera
  final String imagePath;
  final OnUpdateImageCallback onImageChanged;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();

  ImagePickerWidget({this.imagePath, this.onImageChanged});
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<FilePickerCross> _imageStateFuture;
  FilePickerCross _imageState;
  String _imagePathState;

  void initState() {
    _imagePathState = widget.imagePath;
    if (_imagePathState != null) {
      _imageStateFuture =
          FilePickerCross.fromInternalPath(path: _imagePathState);
    }
    super.initState();
  }

  _imgFromCamera() async {
    print("im here");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraCamera(
                  onFile: (file) async {
                    final FilePickerCross imageData =
                        FilePickerCross(await file.readAsBytes());
                    final String path =
                        STORAGE_PATH + DateTime.now().toString() + ".png";
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

  _imgFromStorage() async {
    FilePickerCross image =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    final String path = STORAGE_PATH + DateTime.now().toString() + ".png";
    image.saveToPath(path: path);
    setState(() {
      _imageState = image;
      _imagePathState = path;
      widget.onImageChanged(_imagePathState);
    });
  }

  //displays menu to select from Gallery or take new Picture from Camera
  void _showPicker(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      await _imgFromStorage();
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Photo Library'),
                        onTap: () async {
                          await _imgFromStorage();
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Camera'),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          _showPicker(context);
        },
        child: _imagePathState != null //|| _imagePathState.isEmpty
            ? _imageState == null
                ? FutureBuilder(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64))),
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
                            child: Center(child: CircularProgressIndicator()));
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
                                BorderRadius.all(Radius.circular(64))),
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.defaultImage),
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
                        borderRadius: BorderRadius.all(Radius.circular(64))),
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
}

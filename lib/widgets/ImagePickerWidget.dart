import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef void OnUpdateImageCallback(String image);

const String STORAGE_PATH = "assets/images/";

class ImagePickerWidget extends StatefulWidget {
  //config:

  final int imageQuality = 50;
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
  final ImagePicker _imagePicker = ImagePicker();

  void initState() {
    _imagePathState = widget.imagePath;
    if (_imagePathState != null) {
      _imageStateFuture =
          FilePickerCross.fromInternalPath(path: _imagePathState);
      print(_imagePathState);
    }
    super.initState();
  }

  _imgFromCamera() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: widget.imageQuality);
    final FilePickerCross imageData =
        FilePickerCross(await image.readAsBytes());
    await imageData.saveToPath(path: "$STORAGE_PATH/x.jpg");
    setState(() {
      _imagePathState = "$STORAGE_PATH/x.jpg";
      _imageState = imageData;
      widget.onImageChanged(_imagePathState);
    });
  }

  _imgFromGallery() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: widget.imageQuality);
    final FilePickerCross imageData =
        FilePickerCross(await image.readAsBytes());
    imageData.saveToPath(path: _imagePathState ?? "$STORAGE_PATH /x");
    setState(() {
      _imagePathState = "$STORAGE_PATH/x";
      _imageState = imageData;
      widget.onImageChanged(_imagePathState);
    });
  }

  //displays menu to select from Gallery or take new Picture from Camera
  void _showPicker(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      FilePickerCross image = await FilePickerCross.importFromStorage(
          fileExtension: "jpg, png", type: FileTypeCross.image);
      image.saveToPath(path: "$STORAGE_PATH/x");
      setState(() {
        _imageState = image;
        _imagePathState = _imagePathState ?? "$STORAGE_PATH/x";
      });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () async {
                          await _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () async {
                        await _imgFromCamera();
                        Navigator.of(context).pop();
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

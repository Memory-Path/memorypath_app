import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef void OnUpdateImageCallback(String image);

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
  Future<FilePickerCross> _imageState;
  String _imagePathState;
  final ImagePicker _imagePicker = ImagePicker();

  void initState() {
    _imagePathState = widget.imagePath;
    if (_imagePathState != null) {
      _imageState = FilePickerCross.fromInternalPath(path: _imagePathState);
    }
    super.initState();
  }

  _imgFromCamera() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: widget.imageQuality);
    setState(() {
      _imagePathState = image.path;
      _imageState = FilePickerCross.fromInternalPath(path: _imagePathState);
      widget.onImageChanged(_imagePathState);
    });
  }

  _imgFromGallery() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: widget.imageQuality);

    setState(() {
      _imagePathState = image.path;
      _imageState = FilePickerCross.fromInternalPath(path: _imagePathState);
      widget.onImageChanged(_imagePathState);
    });
  }

  //displays menu to select from Gallery or take new Picture from Camera
  void _showPicker(context) {
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
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: _imagePathState != null //|| _imagePathState.isEmpty
            ? FutureBuilder(
                future: _imageState,
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

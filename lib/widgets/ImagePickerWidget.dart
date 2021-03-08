import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

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

  FilePickerCross _imageState;
  final ImagePicker _imagePicker = ImagePicker();

  void initState() async {
    _imageState = await FilePickerCross.fromInternalPath(path: widget.imagePath);
    super.initState();
  }

  _imgFromCamera() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera,
        imageQuality: widget.imageQuality
    );
    FilePickerCross pickedFile = await FilePickerCross.fromInternalPath(path: image.path);
    setState(() {
      _imageState = pickedFile;
      widget.onImageChanged(image.path);
    });
  }

  _imgFromGallery() async {
    final PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: widget.imageQuality
    );
    FilePickerCross pickedFile = await FilePickerCross.fromInternalPath(path: image.path);
    setState(() {
      _imageState = pickedFile;
      widget.onImageChanged(image.path);
    });
  }

  //displays menu to select from Gallery or take new Picture from Camera
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
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
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _imageState!=null ? _imageState : AssetImage(widget.defaultImage),
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
          )
        );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class ImagePickerWidget extends StatefulWidget {

  //config:
  final int imageQuality = 50;
  final String defaultImage = "";
  // image that is lately filled by Gallery or Camera
  final FilePickerCross image;
  final Function onImageChanged;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();

  ImagePickerWidget({this.image, this.onImageChanged});
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  FilePickerCross imageState;
  final ImagePicker imagePicker = ImagePicker();

  void initState(){
    imageState = widget.image;
    super.initState();
  }

  _imgFromCamera() async {
    final PickedFile image = await imagePicker.getImage(
        source: ImageSource.camera,
        imageQuality: widget.imageQuality
    );
    FilePickerCross pickedFile = await FilePickerCross.fromInternalPath(path: image.path);
    setState(() {
      imageState = pickedFile;
    });
  }

  _imgFromGallery() async {
    final PickedFile image = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: widget.imageQuality
    );
    FilePickerCross pickedFile = await FilePickerCross.fromInternalPath(path: image.path);
    setState(() {
      imageState = pickedFile;
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
              image: imageState!=null ? imageState : AssetImage(widget.defaultImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[700],
              ),
            ),
            ),
          )
        );
  }
}

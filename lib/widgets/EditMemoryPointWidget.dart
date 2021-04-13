import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';
import 'package:mobile/widgets/TitleTextField.dart';

/// Draft of the MemoryPointSheet, where it is possible to fill in the Learning-Content for Memorization in the [PracticePage]

class EditMemoryPointWidget extends StatefulWidget {
  /// The actual Memory-Point ([MemoryPointDb]) that is edited in this Widget
  final MemoryPointDb memoryPoint;

  @override
  _EditMemoryPointWidgetState createState() => _EditMemoryPointWidgetState();

  EditMemoryPointWidget({
    this.memoryPoint,
  });
}

class _EditMemoryPointWidgetState extends State<EditMemoryPointWidget> {
  /// TextController to track the User-Input
  TextEditingController _questionController;
  TextEditingController _answerController;

  /// MemoryPoint-State to track the actual values that the User inserted/edited
  MemoryPointDb _memoryPointDbState;

  @override
  void initState() {
    ///Initial setting of the values for the Widget-State
    _memoryPointDbState = widget.memoryPoint;
    _questionController =
        TextEditingController(text: _memoryPointDbState.question);
    _answerController = TextEditingController(text: _memoryPointDbState.answer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width),
      child: ListView(
        shrinkWrap: true,
        children: [
          ///TextField to edit the Title of the MemoryPoint
          TitleTextField(_onMemoryPointNameChanged, _memoryPointDbState.name),
          ListTile(
              title: Container(
            constraints: BoxConstraints(minHeight: 128),
            child: ImagePickerWidget(
              imagePath: _memoryPointDbState.image,
              onImageChanged: updateImage,
            ),
          )),
          TextField(
            controller: _questionController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Question, Keyword or Note'),
            onSubmitted: (String question) {
              setState(() {
                _memoryPointDbState.question = question;
              });
            },
          ),

          ///lately replaced by a RichTextEditor-Field
          TextField(
            controller: _answerController,
            // maxLines: null,
            // keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Answer'),
            onSubmitted: (String answer) {
              setState(() {
                _memoryPointDbState.answer = answer;
              });
            },
          ),

          /// Button Row for either Deletion or Accepting the MemoryPoint
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  _onMemoryPointDelete();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete),
                label: Text("Delete"),
              ),
              TextButton.icon(
                icon: Icon(Icons.check),
                label: Text("Accept"),
                onPressed: () {
                  if (_memoryPointIsValid()) {
                    _onMemoryPointUpdate(_memoryPointDbState);
                    Navigator.of(context).pop();
                  }

                  /// TODO: SnackBarStyle
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Memory-Point not valid!\n You have to set all Parameters before submitting.")));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  ///dispose the TextController when Widget is disposed
  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  ///Callback for the [ImagePickerWidget] to track the new Path of the Image, selected from the User
  void updateImage(String image) {
    _memoryPointDbState.image = image;
  }

  ///Logic check, if all fields are set properly
  bool _memoryPointIsValid() {
    if (_memoryPointDbState.name != null &&
        _memoryPointDbState.name.isNotEmpty &&
        _memoryPointDbState.image != null &&
        _memoryPointDbState.answer != null &&
        _memoryPointDbState.answer.isNotEmpty &&
        _memoryPointDbState.question != null &&
        _memoryPointDbState.question.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  ///Callback, when a MemoryPoint is deleted
  void _onMemoryPointDelete() {
    widget.memoryPoint.delete();
  }

  ///Callback, when a MemoryPoint is updated
  void _onMemoryPointUpdate(MemoryPointDb memoryPointDbState) {
    widget.memoryPoint.name = _memoryPointDbState.name;
    widget.memoryPoint.image = _memoryPointDbState.image;
    widget.memoryPoint.question = _memoryPointDbState.question;
    widget.memoryPoint.answer = _memoryPointDbState.answer;
  }

  /// Callback for the [TitleTExtField]
  void _onMemoryPointNameChanged(String title) {
    _memoryPointDbState.name = title;
  }
}

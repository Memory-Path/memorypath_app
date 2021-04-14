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

  @override
  void initState() {
    ///Initial setting of the values for the Widget-State
    _questionController =
        TextEditingController(text: widget.memoryPoint.question);
    _answerController = TextEditingController(text: widget.memoryPoint.answer);
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
          TitleTextField(_onMemoryPointNameChanged, widget.memoryPoint.name),
          ListTile(
              title: Container(
            constraints: BoxConstraints(minHeight: 128),
            child: ImagePickerWidget(
              imagePath: widget.memoryPoint.image,
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
                widget.memoryPoint.question = question;
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
                widget.memoryPoint.answer = answer;
              });
            },
          ),
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
    widget.memoryPoint.image = image;
  }

  /// Callback for the [TitleTExtField]
  void _onMemoryPointNameChanged(String title) {
    widget.memoryPoint.name = title;
  }
}

import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';
import 'package:mobile/widgets/TitleTextField.dart';

class MemoryPointEditWidget extends StatefulWidget {
  final MemoryPointDb memoryPoint;

  @override
  _MemoryPointEditWidgetState createState() => _MemoryPointEditWidgetState();

  MemoryPointEditWidget({
    this.memoryPoint,
  });
}

class _MemoryPointEditWidgetState extends State<MemoryPointEditWidget> {
  TextEditingController _questionController;
  TextEditingController _answerController;
  MemoryPointDb _memoryPointDbState;

  @override
  void initState() {
    //Setting Values for Widget-State
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

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void updateImage(String image) {
    _memoryPointDbState.image = image;
  }

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

  void _onMemoryPointDelete() {
    widget.memoryPoint.delete();
  }

  void _onMemoryPointUpdate(MemoryPointDb memoryPointDbState) {
    widget.memoryPoint.name = _memoryPointDbState.name;
    widget.memoryPoint.image = _memoryPointDbState.image;
    widget.memoryPoint.question = _memoryPointDbState.question;
    widget.memoryPoint.answer = _memoryPointDbState.answer;
  }

  void _onMemoryPointNameChanged(String title) {
    _memoryPointDbState.name = title;
  }
}

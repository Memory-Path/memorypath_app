import 'package:flutter/material.dart';
import 'package:mobile/src/MemoryPoint.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';
import 'package:mobile/widgets/maps/StaticMapView.dart';

typedef Future<void> OnMemoryPointChangedCallback(MemoryPoint memoryPoint);

class MemoryPointEditWidget extends StatefulWidget {
  final String memoryPathName;
  final String memoryPathTopic;
  final MemoryPoint memoryPoint;
  final StaticMapView mapView;
  final OnMemoryPointChangedCallback onMemoryPointUpdate;
  final OnMemoryPointChangedCallback onMemoryPointDelete;

  @override
  _MemoryPointEditWidgetState createState() => _MemoryPointEditWidgetState();

  MemoryPointEditWidget(
      {this.memoryPathName,
      this.memoryPathTopic,
      this.memoryPoint,
      this.mapView,
      this.onMemoryPointUpdate,
      this.onMemoryPointDelete});
}

class _MemoryPointEditWidgetState extends State<MemoryPointEditWidget> {
  TextEditingController _nameController;
  bool _isEditingName = false;
  TextEditingController _questionController;
  TextEditingController _answerController;
  MemoryPoint _memoryPointState;

  @override
  void initState() {
    //Setting Values for Widget-State
    _memoryPointState = widget.memoryPoint;
    _nameController = TextEditingController(text: _memoryPointState.name);
    _questionController =
        TextEditingController(text: _memoryPointState.question);
    _answerController = TextEditingController(text: _memoryPointState.answer);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  /// TODO: move into separate class
  Widget _editTitleTextField() {
    if (_isEditingName)
      return TextField(
        onSubmitted: (newName) {
          setState(() {
            _memoryPointState.name = newName;
            _isEditingName = false;
          });
        },
        autofocus: true,
        controller: _nameController,
      );
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingName = true;
        });
      },
      child: Text(
        _memoryPointState.name ?? "",
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  void updateImage(String image) {
    _memoryPointState.image = image;
  }

  bool _memoryPointIsValid() {
    if (_memoryPointState.name != null &&
        _memoryPointState.name.isNotEmpty &&
        _memoryPointState.image != null &&
        _memoryPointState.latlng != null &&
        _memoryPointState.answer != null &&
        _memoryPointState.answer.isNotEmpty &&
        _memoryPointState.question != null &&
        _memoryPointState.question.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(widget.memoryPathName ?? "ToDo: Throw Error")),

          /// TODO: use `TODO:` instead of `ToDo:`
          ListTile(title: Text(widget.memoryPathTopic ?? "ToDo: Throw Error")),
          _editTitleTextField(),
          ListTile(
              title: ImagePickerWidget(
            imagePath: _memoryPointState.image,
            onImageChanged: updateImage,
          )),
          ListTile(title: widget.mapView),
          ListTile(title: Text("Question:")),

          /// TODO: Semantics: Should use label and helper instead of `Text`
          TextField(
            controller: _questionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: _memoryPointState.question != null

                  /// TODO: Nope, just kick out the null check and leave the label there. Semantics: strike away the trailing `...`
                  ? null
                  : "Enter question...",
            ),
            onSubmitted: (String question) {
              setState(() {
                _memoryPointState.question = question;
              });
            },
          ),
          ListTile(title: Text("Answer:")),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText:

                  /// TODO: Nope, just kick out the null check and leave the label there. Semantics: strike away the trailing `...`
                  _memoryPointState.answer != null ? null : "Enter Answer...",
            ),
            onSubmitted: (String answer) {
              setState(() {
                _memoryPointState.answer = answer;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () async {
                  /// TODO: No await, no async
                  await widget.onMemoryPointDelete;
                },
                icon: Icon(Icons.delete),
                label: Text("Delete"),
              ),
              TextButton.icon(
                icon: Icon(Icons.check),
                label: Text("Accept"),
                onPressed: () async {
                  if (_memoryPointIsValid()) {
                    await widget.onMemoryPointUpdate;
                  }

                  /// TODO: Throw proper exception. Alert dialogue should be shown instead of thrown
                  throw AlertDialog(
                    title: Text("Memory-Point not valid"),
                    content: Text(
                        "You have to set all Parameters before submitting!"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("ok"))
                    ],
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

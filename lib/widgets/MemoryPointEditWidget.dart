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
    _nameController = _memoryPointState.name != null
        ? TextEditingController(text: _memoryPointState.name)
        : TextEditingController();
    _questionController = _memoryPointState.question != null
        ? TextEditingController(text: _memoryPointState.question)
        : TextEditingController();
    _answerController = _memoryPointState.answer != null
        ? TextEditingController(text: _memoryPointState.answer)
        : TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

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
        _memoryPointState.name,
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(widget.memoryPathName ?? "ToDo: Throw Error")),
            SizedBox(height: 8),
            Center(child: Text(widget.memoryPathTopic ?? "ToDo: Throw Error")),
            SizedBox(height: 8),
            _editTitleTextField(),
            SizedBox(height: 8),
            Container(
                height: 128,
                width: 512,
                child: ImagePickerWidget(
                  imagePath: _memoryPointState.image,
                  onImageChanged: updateImage,
                )),
            Container(height: 64, width: 512, child: widget.mapView),
            SizedBox(height: 8),
            Text("Question:"),
            SizedBox(height: 8),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: _memoryPointState.question != null
                    ? null
                    : "Enter question...",
              ),
              onSubmitted: (String question) {
                setState(() {
                  _memoryPointState.question = question;
                });
              },
            ),
            SizedBox(height: 8),
            Text("Answer:"),
            SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:
                    _memoryPointState.answer != null ? null : "Enter Answer...",
              ),
              onSubmitted: (String answer) {
                setState(() {
                  _memoryPointState.answer = answer;
                });
              },
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () async {
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
      ),
    );
  }
}
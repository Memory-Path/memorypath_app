import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/MemoryPoint.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';

class MemoryPointEditWidget extends StatefulWidget {
  final String memoryPathName;
  final String memoryPathTopic;
  final MemoryPoint memoryPoint;
  final Function(MemoryPoint) onMemoryPointUpdate;
  final Function(int) onMemoryPointDelete;

  @override
  _MemoryPointEditWidgetState createState() => _MemoryPointEditWidgetState();

  MemoryPointEditWidget(
      {this.memoryPathName,
      this.memoryPathTopic,
      this.memoryPoint,
      this.onMemoryPointUpdate,
      this.onMemoryPointDelete});
}

class _MemoryPointEditWidgetState extends State<MemoryPointEditWidget> {
  TextEditingController nameController;
  bool _isEditingName = false;
  TextEditingController questionController;
  TextEditingController answerController;
  MemoryPoint memoryPointState;

  @override
  void initState() {
    //Setting Values for Widget-State
    memoryPointState = widget.memoryPoint;
    nameController = memoryPointState.name != null
        ? TextEditingController(text: memoryPointState.name)
        : TextEditingController();
    questionController = memoryPointState.question != null
        ? TextEditingController(text: memoryPointState.question)
        : TextEditingController();
    answerController = memoryPointState.answer != null
        ? TextEditingController(text: memoryPointState.answer)
        : TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField() {
    if (_isEditingName)
      return TextField(
        onSubmitted: (newName) {
          setState(() {
            memoryPointState.name = newName;
            _isEditingName = false;
          });
        },
        autofocus: true,
        controller: nameController,
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingName = true;
        });
      },
      child: Text(
        memoryPointState.name,
      ),
    );
  }

  void updateImage (FilePickerCross image){
    memoryPointState.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //ToDo: Error Handling if Strings==null
            Center(
                child: Text(widget.memoryPathName != null
                    ? widget.memoryPathName
                    : "ToDo: Throw Error")),
            SizedBox(height: 8),
            Center(
                child: Text(widget.memoryPathTopic != null
                    ? widget.memoryPathTopic
                    : "ToDo: Throw Error")),
            SizedBox(height: 8),
            _editTitleTextField(),
            SizedBox(height: 8),
            Container(
                height: 128,
                width: 512,
                child: ImagePickerWidget(image: memoryPointState.image, onImageChanged: updateImage,)),
            Container(
              height: 64,
              width: 512,
              //toDo: child: MapView(),
            ),
            SizedBox(height: 8),
            Text("Question:"),
            SizedBox(height: 8),
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: memoryPointState.question != null
                    ? null
                    : "Enter question...",
              ),
            ),
            SizedBox(height: 8),
            Text("Answer:"),
            SizedBox(height: 8),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: memoryPointState.answer != null
                    ? null
                    : "Enter Answer...",
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: widget.onMemoryPointDelete(memoryPointState.id),
                  child: Icon(Icons.delete),
                ),
                FloatingActionButton(
                  onPressed: widget.onMemoryPointUpdate(memoryPointState),
                  child: Icon(Icons.check),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
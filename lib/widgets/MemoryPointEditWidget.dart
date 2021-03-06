import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';


class MemoryPointEditWidget extends StatefulWidget {
  final String memoryPathName;
  final String memoryPathTopic;
  final int memoryPointId;

  @override
  _MemoryPointEditWidgetState createState() => _MemoryPointEditWidgetState();

  MemoryPointEditWidget(
      {this.memoryPathName,
      this.memoryPathTopic,
      this.memoryPointId});
}

class _MemoryPointEditWidgetState extends State<MemoryPointEditWidget> {
  TextEditingController _nameController;
  bool _isEditingName = false;
  TextEditingController _questionController;
  TextEditingController _answerController;
  MemoryPointDb _memoryPointState;
  Box _memoryPointBox;

  @override
  void initState() {
    //Setting Values for Widget-State
    _memoryPointBox = Hive.box<MemoryPointDb>(HIVE_MEMORY_POINTS);
    _memoryPointState = _memoryPointBox.get(widget.memoryPointId);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //ToDo: Error Handling if Strings==null
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
                Container(
                  height: 64,
                  width: 512,
                  //toDo: child: MapView(),
                ),
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
                      onPressed: () {

                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete"),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.check),
                      label: Text("Accept"),
                    ),
                  ],
                )
              ],
        ),
      ),
    );
  }
}

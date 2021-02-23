import 'package:flutter/material.dart';
import 'package:mobile/src/MemoryPoint.dart';
import 'package:mobile/widgets/ImagePickerWidget.dart';

class MemoryPointEditWidget extends StatefulWidget {
  final MemoryPoint memoryPoint;
  final Function onMemoryPointChanged;

  @override
  _MemoryPointEditWidgetState createState() => _MemoryPointEditWidgetState();

  MemoryPointEditWidget({this.memoryPoint, this.onMemoryPointChanged});
}

class _MemoryPointEditWidgetState extends State<MemoryPointEditWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  MemoryPoint memoryPointState;

  @override
  void initState() {
    memoryPointState = widget.memoryPoint;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("MemoryPathTitle"),
          Text("MemoryPathTopic"),
          TextField(
            controller: nameController,
          ),
          ImagePickerWidget(image: memoryPointState.image),
          Text("Question:"),
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: memoryPointState.question != null
                  ? memoryPointState.question
                  : "Enter question...",
            ),
          ),
          Text("Answer:"),
          TextField(
            controller: answerController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: memoryPointState.answer != null
                  ? memoryPointState.answer
                  : "Enter Answer...",
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                //toDo: Functionality
                onPressed: () {},
                icon: Icon(Icons.delete),
                label: Text(""),
              ),
              ElevatedButton.icon(
                //toDo: Functionality
                onPressed: () {},
                icon: Icon(Icons.check),
                label: Text(""),
              ),
            ],
          )
        ],
      ),
    );
  }
}

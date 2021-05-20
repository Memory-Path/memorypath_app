import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnTitleChangedCallback = void Function(String title);

class TitleTextField extends StatefulWidget {
  const TitleTextField(this.onTitleChanged, this.title);
  final OnTitleChangedCallback onTitleChanged;
  final String title;

  @override
  _TitleTextFieldState createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  bool _isEditingTitle;
  String _titleState;
  TextEditingController _titleController;

  @override
  void initState() {
    _titleState = widget.title;
    _titleController = TextEditingController(text: widget.title);
    _isEditingTitle = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditingTitle)
      return TextField(
        onSubmitted: (String newTitle) {
          setState(() {
            _titleState = newTitle;
            widget.onTitleChanged(newTitle);
            _isEditingTitle = false;
          });
        },
        autofocus: true,
        controller: _titleController,
      );
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingTitle = true;
        });
      },
      child: Text(
        _titleState ?? '',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
    //return Container();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

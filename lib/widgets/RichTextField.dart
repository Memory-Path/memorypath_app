import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

typedef void OnRichTextUpdate(String richText);

class RichTextField extends StatefulWidget {
  final String markdown;
  final OnRichTextUpdate onRichTextUpdate;

  RichTextField({this.markdown, this.onRichTextUpdate});

  @override
  _RichTextFieldState createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  ZefyrController _controller;
  FocusNode _focusNode;

  final doc =
      r'[{"insert":"Zefyr"},{"insert":"\n","attributes":{"heading":1}},{"insert":"Soft and gentle rich text editing for Flutter applications.","attributes":{"i":true}},{"insert":"\n"},{"insert":"​","attributes":{"embed":{"type":"image","source":"asset://assets/breeze.jpg"}}},{"insert":"\n"},{"insert":"Photo by Hiroyuki Takeda.","attributes":{"i":true}},{"insert":"\nZefyr is currently in "},{"insert":"early preview","attributes":{"b":true}},{"insert":". If you have a feature request or found a bug, please file it at the "},{"insert":"issue tracker","attributes":{"a":"https://github.com/memspace/zefyr/issues"}},{"insert":'
      r'".\nDocumentation"},{"insert":"\n","attributes":{"heading":3}},{"insert":"Quick Start","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/quick_start.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Data Format and Document Model","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/data_and_document.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Style Attributes","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/attr'
      r'ibutes.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Heuristic Rules","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/heuristics.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"FAQ","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/faq.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Clean and modern look"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Zefyr’s rich text editor is built with simplicity and fle'
      r'xibility in mind. It provides clean interface for distraction-free editing. Think Medium.com-like experience.\nMarkdown inspired semantics"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Ever needed to have a heading line inside of a quote block, like this:\nI’m a Markdown heading"},{"insert":"\n","attributes":{"block":"quote","heading":3}},{"insert":"And I’m a regular paragraph"},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"Code blocks"},{"insert":"\n","attributes":{"headin'
      r'g":2}},{"insert":"Of course:\nimport ‘package:flutter/material.dart’;"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"import ‘package:zefyr/zefyr.dart’;"},{"insert":"\n\n","attributes":{"block":"code"}},{"insert":"void main() {"},{"insert":"\n","attributes":{"block":"code"}},{"insert":" runApp(MyWAD());"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"}"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"\n\n\n"}]';

  @override
  void initState() {
    final Delta delta = Delta.fromJson(json.decode(doc) as List);
    _focusNode = FocusNode();
    _controller = ZefyrController(NotusDocument.fromDelta(delta));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZefyrEditor(
      padding: EdgeInsets.all(16.0),
      controller: _controller,
      focusNode: _focusNode,
    );
  }

  NotusDocument _convertStringToNotusDocument(String string) {
    return NotusDocument.fromJson(jsonDecode(string));
  }
}

// class RawEditorState extends EditorState {
//   @override
//   TextEditingValue textEditingValue;
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//   @override
//   void hideToolbar() {
//     // TODO: implement hideToolbar
//   }
//
//   @override
//   // TODO: implement renderEditor
//   RenderEditor get renderEditor => throw UnimplementedError();
//
//   @override
//   void requestKeyboard() {
//     // TODO: implement requestKeyboard
//   }
//
//   @override
//   // TODO: implement selectionOverlay
//   EditorTextSelectionOverlay get selectionOverlay => throw UnimplementedError();
//
//   @override
//   bool showToolbar() {
//     // TODO: implement showToolbar
//     throw UnimplementedError();
//   }
// }

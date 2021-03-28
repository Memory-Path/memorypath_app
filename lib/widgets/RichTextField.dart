// import 'package:flutter/material.dart';
// import 'package:quill_delta/quill_delta.dart';
// import 'package:zefyr/zefyr.dart';
//
// typedef void OnRichTextUpdate(String richText);
//
// class RichTextField extends StatefulWidget {
//   final String markdown;
//   final OnRichTextUpdate onRichTextUpdate;
//
//   RichTextField({this.markdown, this.onRichTextUpdate});
//
//   @override
//   _RichTextFieldState createState() => _RichTextFieldState();
// }
//
// class _RichTextFieldState extends State<RichTextField> {
//   /// Allows to control the editor and the document.
//   ZefyrController _controller;
//
//   /// Zefyr editor like any other input field requires a focus node.
//   FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     // Here we must load the document and pass it to Zefyr controller.
//     final document = _loadDocument();
//     _controller = ZefyrController(document);
//     _focusNode = FocusNode();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Note that the editor requires special `ZefyrScaffold` widget to be
//     // one of its parents.
//     return ZefyrEditor(
//       padding: EdgeInsets.all(16),
//       controller: _controller,
//       focusNode: _focusNode,
//     );
//   }
//
//   /// Loads the document to be edited in Zefyr.
//   NotusDocument _loadDocument() {
//     // For simplicity we hardcode a simple document with one line of text
//     // saying "Zefyr Quick Start".
//     // (Note that delta must always end with newline.)
//     final Delta delta = Delta()..insert("Zefyr Quick Start\n");
//     return NotusDocument.fromDelta(delta);
//   }
// }
//
// /// Provides necessary layout for [ZefyrEditor].
// class ZefyrScaffold extends StatefulWidget {
//   final Widget child;
//
//   const ZefyrScaffold({Key key, this.child}) : super(key: key);
//
//   static ZefyrScaffoldState of(BuildContext context) {
//     final widget =
//         context.dependOnInheritedWidgetOfExactType<_ZefyrScaffoldAccess>();
//     return widget.scaffold;
//   }
//
//   @override
//   ZefyrScaffoldState createState() => ZefyrScaffoldState();
// }
//
// class ZefyrScaffoldState extends State<ZefyrScaffold> {
//   WidgetBuilder _toolbarBuilder;
//
//   void showToolbar(WidgetBuilder builder) {
//     setState(() {
//       _toolbarBuilder = builder;
//     });
//   }
//
//   void hideToolbar(WidgetBuilder builder) {
//     if (_toolbarBuilder == builder) {
//       setState(() {
//         _toolbarBuilder = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final toolbar =
//         (_toolbarBuilder == null) ? Container() : _toolbarBuilder(context);
//     return _ZefyrScaffoldAccess(
//       scaffold: this,
//       child: Column(
//         children: <Widget>[
//           Expanded(child: widget.child),
//           toolbar,
//         ],
//       ),
//     );
//   }
// }
//
// class _ZefyrScaffoldAccess extends InheritedWidget {
//   final ZefyrScaffoldState scaffold;
//
//   _ZefyrScaffoldAccess({Widget child, this.scaffold}) : super(child: child);
//
//   @override
//   bool updateShouldNotify(_ZefyrScaffoldAccess oldWidget) {
//     return oldWidget.scaffold != scaffold;
//   }
// }

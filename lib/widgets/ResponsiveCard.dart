import 'package:flutter/material.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;

  const ResponsiveCard({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        child: Container(
            constraints: BoxConstraints(maxWidth: 768),
            child: Card(
              child: child,
            )));
  }
}

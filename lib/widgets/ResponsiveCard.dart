import 'package:flutter/material.dart';

class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Card(
              child: child,
            )));
  }
}

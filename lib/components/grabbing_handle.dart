import 'package:flutter/material.dart';

class GrabbingHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Center(
        child: Container(
          height: 8,
          width: 48,
          child: Tooltip(
            message: 'Drag to open',
            child: Material(
              elevation: 2,
              color: Theme.of(context).colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ),
    );
  }
}

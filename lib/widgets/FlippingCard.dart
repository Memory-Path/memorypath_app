import 'dart:math';

import 'package:flutter/material.dart';

class FlippingCard extends StatefulWidget {
  final Widget front;
  final Widget rear;
  final double height;

  const FlippingCard({Key key, this.front, this.rear, this.height})
      : super(key: key);

  @override
  _FlippingCardState createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  bool _showFrontSide;
  bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        child: Container(
            constraints: BoxConstraints(maxWidth: 768),
            child: GestureDetector(
              onTap: _switchCard,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: __transitionBuilder,
                layoutBuilder: (widget, list) =>
                    Stack(children: [widget, ...list]),
                child: _showFrontSide ? _buildFront() : _buildRear(),
                switchInCurve: Curves.easeInBack,
                switchOutCurve: Curves.easeInBack.flipped,
              ),
            )));
  }

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = !_flipXAxis;
    });
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
    _changeRotationAxis();
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront() {
    return Card(
        key: ValueKey(true),
        child: Container(
          child: widget.front,
          height: widget.height,
        ));
  }

  Widget _buildRear() {
    return Card(
      key: ValueKey(false),
      child: Container(child: widget.rear, height: widget.height),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class FlippingCard extends StatefulWidget {
  const FlippingCard({Key key, this.front, this.rear, this.height})
      : super(key: key);
  final Widget front;
  final Widget rear;
  final double height;

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
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 768),
            child: GestureDetector(
              onTap: _switchCard,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: __transitionBuilder,
                layoutBuilder: (Widget widget, List<Widget> list) =>
                    Stack(children: <Widget>[widget, ...list]),
                child: _showFrontSide ? _buildFront() : _buildRear(),
                switchInCurve: Curves.easeInBack,
                switchOutCurve: Curves.easeInBack.flipped,
              ),
            )));
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final Animation<double> rotateAnim = Tween<double>(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (BuildContext context, Widget widget) {
        final bool isUnder = ValueKey<bool>(_showFrontSide) != widget.key;
        double tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final double value =
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
        key: const ValueKey<bool>(true),
        child: Container(
          child: widget.front,
          height: widget.height,
        ));
  }

  Widget _buildRear() {
    return Card(
      key: const ValueKey<bool>(false),
      child: Container(child: widget.rear, height: widget.height),
    );
  }
}

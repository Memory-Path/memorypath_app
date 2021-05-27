import 'package:flutter/material.dart';

class CenterProgress extends StatefulWidget {
  const CenterProgress({this.label = ''});
  final String label;

  @override
  _CenterProgressState createState() => _CenterProgressState();
}

class _CenterProgressState extends State<CenterProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Color>? _colorTween;
  late TweenSequence<Color> _tweenSequence;

  @override
  void initState() {
    _tweenSequence = TweenSequence<Color>(<TweenSequenceItem<Color>>[
      TweenSequenceItem<Color>(
          tween: ColorTween(begin: Colors.green, end: Colors.lightBlue) as Animatable<Color>,
          weight: 1),
      TweenSequenceItem<Color>(
          tween: ColorTween(begin: Colors.lightBlue, end: Colors.lightBlue) as Animatable<Color>,
          weight: 2),
      TweenSequenceItem<Color>(
          tween: ColorTween(begin: Colors.lightBlue, end: Colors.green) as Animatable<Color>,
          weight: 1),
      TweenSequenceItem<Color>(
          tween: ColorTween(begin: Colors.green, end: Colors.green) as Animatable<Color>, weight: 2),
    ]);

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _colorTween = _tweenSequence.animate(_animationController);
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorTween!,
        builder: (BuildContext context, Widget? child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Loading...',
                      valueColor: _colorTween,
                    ),
                  ),
                  if (widget.label != '')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.label),
                    ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

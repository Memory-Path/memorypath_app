import 'package:flutter/material.dart';
import 'package:mobile/main.dart';

class SplashScreen extends StatefulWidget {
  static RegExp routeMatch = RegExp(r'^\/$');
  final String requestedRoute;

  const SplashScreen({Key key, this.requestedRoute = '/home'})
      : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadWhatever();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void loadWhatever() async {
    // TODO: Login etc. may be handled here
    await Future.delayed(Duration(seconds: 1), () {
      initialized = true;
      Navigator.of(context).pushReplacementNamed(widget.requestedRoute);
    });
  }
}

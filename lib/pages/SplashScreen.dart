import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static RegExp routeMatch = RegExp(r'^\/$');
  final String requestedRoute;
  final dynamic data;

  const SplashScreen({Key key, this.requestedRoute = '/home', this.data})
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
      Navigator.of(context)
          .pushNamed(widget.requestedRoute, arguments: widget.data);
    });
  }
}

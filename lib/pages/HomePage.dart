import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final RegExp routeMatch = RegExp(r'^\/home$');
  final dynamic data;

  const HomePage({Key key, this.data}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Home Page'),
            if (widget.data != null)
              Text('Data provided: ${widget.data.toString()}')
          ],
        ),
      ),
    );
  }
}

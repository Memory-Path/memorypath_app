import 'package:flutter/material.dart';
import 'package:map_api/map_api.dart';
import 'package:mobile/main.dart';
import 'package:mobile/mapbox_api_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key, this.requestedRoute = '/home'})
      : super(key: key);
  static final RegExp routeMatch = RegExp(r'^\/$');
  final String requestedRoute;

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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> loadWhatever() async {
    // TODO(MemoryPath): Login etc. may be handled here,
    await Future<Null>.delayed(const Duration(seconds: 1));
    MapBoxApi.init(MAPBOX_API_KEY);
    initialized = true;
    Navigator.of(context).pushReplacementNamed(widget.requestedRoute);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/geoMaps.dart';
import 'Screens/map.dart';

class MapHomePage extends StatelessWidget {
  final locatorService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => locatorService.getLocation(),
      child: HospMap(),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class DriverConvenienceMapScreen extends StatelessWidget {
  const DriverConvenienceMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Map')),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-17.824858, 31.053028),
          zoom: 14.0,
        ),
      ),
    );
  }
}

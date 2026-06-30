import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../core/constants/api_constants.dart';

@RoutePage()
class DriverConvenienceMapScreen extends StatefulWidget {
  final String? bookingId;
  const DriverConvenienceMapScreen({super.key, this.bookingId});

  @override
  State<DriverConvenienceMapScreen> createState() => _DriverConvenienceMapScreenState();
}

class _DriverConvenienceMapScreenState extends State<DriverConvenienceMapScreen> {
  LatLng? _driverLocation;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.bookingId != null) {
      _fetchDriverLocation();
    }
  }

  Future<void> _fetchDriverLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await Injection.httpClient.get(ApiConstants.driverLocation(widget.bookingId!));
      final data = response['data'];
      if (data != null && data['lat'] != null && data['lng'] != null) {
        setState(() {
          _driverLocation = LatLng(
            double.parse(data['lat'].toString()),
            double.parse(data['lng'].toString()),
          );
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Map')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _driverLocation ?? const LatLng(-17.824858, 31.053028),
                    zoom: 14.0,
                  ),
                  markers: _driverLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('driver_location'),
                            position: _driverLocation!,
                            infoWindow: const InfoWindow(title: 'Driver Location'),
                          )
                        }
                      : {},
                ),
    );
  }
}

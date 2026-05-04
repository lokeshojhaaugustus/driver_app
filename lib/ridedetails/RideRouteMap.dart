import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRouteMap extends StatelessWidget {

  final LatLng pickup;
  final LatLng drop;

  const RideRouteMap({
    super.key,
    required this.pickup,
    required this.drop
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: pickup,
        zoom: 12
      ),
      markers: {
        Marker(
          markerId: MarkerId("pickup"),
          position: pickup,
        ),
        Marker(
          markerId: MarkerId("drop"),
          position: drop 
        )
      },
    
    );
  }
}
// lib/newmap/MapService.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  
  static void focusOnLocation({
    required GoogleMapController? mapController,
    required LatLng location,
    double zoomLevel = 16.0,
  }) {
    if (mapController == null) return;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: zoomLevel,
        ),
      ),
    );
  }
}
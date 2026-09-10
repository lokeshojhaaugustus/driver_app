
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/newmap/MapStyleConfig.dart';
import 'package:driver_app/newmap/MapService.dart'; // Import our new helper
import 'package:driver_app/controller/CurrentLocationController.dart'; // Watch coordinates state

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // Default placeholder fallback center
    zoom: 16.0,
  );

  @override
  Widget build(BuildContext context) {
  
    final currentLocation = ref.watch(currentLocationControllerProvider);

 
    if (currentLocation != null && _mapController != null) {
      MapService.focusOnLocation(
        mapController: _mapController,
        location: currentLocation,
      );
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        
        
        myLocationEnabled: currentLocation != null, 

        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          controller.setMapStyle(MapStyleConfig.minimalStyle);
          
          
          if (currentLocation != null) {
            MapService.focusOnLocation(
              mapController: _mapController,
              location: currentLocation,
            );
          }
        },
      ),
    );
  }
}
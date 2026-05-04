import 'package:driver_app/location/LocationService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {

  bool _hasPermission=false;
  GoogleMapController? _mapController;
  LatLng? _currentPos;

  @override
  void initState() {
    super.initState();
    _listenToLocation();
  }

  void _listenToLocation() async {
    _hasPermission = await LocationService.handlePermission();

    if (!_hasPermission) {
      setState(() {});
      return;
    }

    print("✅ Permission granted, starting location stream...");

    LocationService.getLiveLocation().listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPos = latLng;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Center(child: Text("Location permission denied"));
    }

    if (_currentPos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _buildMap(), // ✅ stays constant

        AnimatedBuilder(
          animation: DriverStateManager(),
          builder: (context, _) {
            return _buildOverlayUI(); // ✅ only this rebuilds
          },
        ),
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPos!,
        zoom: 15,
      ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        if (_mapController == null) {
          _mapController = controller; // ✅ only once
        }
      },
      markers: _buildMarkers(),
    );
  }

  Set<Marker> _buildMarkers() {
    final trip = TripService.currentTrip;

    Set<Marker> markers = {};

    // Driver marker
    markers.add(
      Marker(
        markerId: const MarkerId("driver"),
        position: _currentPos!,
      ),
    );

    // Pickup marker
    // if (trip != null && trip.pickupAddress.cordinate != null) {
    //   markers.add(
    //     Marker(
    //       markerId: const MarkerId("pickup"),
    //       position: trip.pickupAddress.cordinate,
    //     ),
    //   );
    // }

    return markers;
  }

  Widget _buildOverlayUI() {
    final driverState = DriverStateManager().state;
    final trip = TripService.currentTrip;

    // OFFLINE
    if (driverState == DriverState.offline) {
      return const Center(child: Text("Offline"));
    }

    // NO TRIP
    if (trip == null) {
      return const SizedBox();
    }

    switch (trip.tripState) {

      case TripState.onPickup:
        return const Center(child: Text("Going to Pickup"));

      case TripState.arrived:
        return Column(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Start Trip"),
            ),
          ],
        );

      case TripState.onTrip:
        return const Center(child: Text("On Trip"));

      case TripState.completed:
        return const SizedBox();
    }
  }

  // =========================
  // MAP STATES
  // =========================

  

  

  
}
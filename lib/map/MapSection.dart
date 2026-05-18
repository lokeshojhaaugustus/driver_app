import 'dart:async';

import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';
import 'package:driver_app/location/LocationService.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/MapService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSubscription;

  LatLng? _currentPos;

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    _listenToLocation();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _listenToLocation() async {
    _hasPermission = await LocationService.handlePermission();
    _isCheckingPermission = false;

    if (!mounted) return;

    if (!_hasPermission) {
      setState(() {});

      return;
    }

    _positionSubscription = LocationService.getLiveLocation().listen((
      Position position,
    ) {
      if (!mounted) return;

      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPos = latLng;

        AppState.currentDriverLocation = latLng;
      });

      final driverId = AppState.currentDriver?.driverId;
      if (driverId != null) {
        DriverCurrentLocationApiService.updateLocation(
          driverId: driverId,
          location: latLng,
        ).catchError((_) {});
      }

      _updateRoute();

      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  Future<void> _updateRoute() async {
    final trip = AppStateService.getCurrentTrip();

    if (trip == null || _currentPos == null) {
      setState(() {
        _polylines = {};
      });

      return;
    }

    LatLng destination;

    // DRIVER -> PICKUP
    if (trip.tripState == TripState.onPickup) {
      destination = LatLng(
        trip.pickupAddress.latitude,
        trip.pickupAddress.longitude,
      );
    }
    // PICKUP -> DROP
    else if (trip.tripState == TripState.onTrip) {
      destination = LatLng(
        trip.dropAddress.latitude,
        trip.dropAddress.longitude,
      );
    }
    // ARRIVED / COMPLETED
    else {
      setState(() {
        _polylines = {};
      });

      return;
    }

    final routePoints = await MapService.getRoutePoints(
      origin: _currentPos!,
      destination: destination,
    );

    if (!mounted) return;

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId("route"),

          points: routePoints,

          width: 5,

          color: Colors.blue,
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      return const Center(child: Text("Location permission denied"));
    }

    if (_currentPos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _buildMap(),

        AnimatedBuilder(
          animation: DriverStateManager(),

          builder: (context, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateRoute();
            });

            return _buildOverlayUI();
          },
        ),
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _currentPos!, zoom: 15),

      myLocationEnabled: true,

      myLocationButtonEnabled: true,

      onMapCreated: (controller) {
        _mapController ??= controller;
      },

      markers: _buildMarkers(),

      polylines: _polylines,
    );
  }

  Set<Marker> _buildMarkers() {
    final trip = AppStateService.getCurrentTrip();

    Set<Marker> markers = {};

    // DRIVER MARKER
    if (_currentPos != null) {
      markers.add(
        Marker(markerId: const MarkerId("driver"), position: _currentPos!),
      );
    }

    if (trip == null) {
      return markers;
    }

    // PICKUP MARKER
    if (trip.tripState == TripState.onPickup) {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),

          position: LatLng(
            trip.pickupAddress.latitude,
            trip.pickupAddress.longitude,
          ),
        ),
      );
    }

    // DROP MARKER
    if (trip.tripState == TripState.onTrip) {
      markers.add(
        Marker(
          markerId: const MarkerId("drop"),

          position: LatLng(
            trip.dropAddress.latitude,
            trip.dropAddress.longitude,
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildOverlayUI() {
    final driverState = DriverStateManager().state;

    final trip = AppStateService.getCurrentTrip();

    // OFFLINE
    if (driverState == DriverState.offline) {
      return Center(child: Lottie.asset("assets/gif/offline.lottie"));
    }

    // ONLINE + NO TRIP
    if (trip == null) {
      return const SizedBox();
    }

    switch (trip.tripState) {
      // GOING TO PICKUP
      case TripState.onPickup:
        return Column(
          children: [
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () async {
                    await TripService.arrivedAtPickup(trip.tripId);

                    _polylines = {};

                    DriverStateManager().refresh();

                    if (mounted) {
                      setState(() {});
                    }
                  },

                  child: const Text("Reached Pickup"),
                ),
              ),
            ),
          ],
        );

      // DRIVER ARRIVED
      case TripState.arrived:
        return Column(
          children: [
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () async {
                    await TripService.startTrip(trip.tripId);

                    DriverStateManager().refresh();

                    _updateRoute();

                    if (mounted) {
                      setState(() {});
                    }
                  },

                  child: const Text("Start Trip"),
                ),
              ),
            ),
          ],
        );

      // ON TRIP
      case TripState.onTrip:
        return Column(
          children: [
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () async {
                    await TripService.endTrip(trip.tripId);

                    _polylines = {};

                    DriverStateManager().refresh();

                    if (mounted) {
                      setState(() {});
                    }
                  },

                  child: const Text("End Trip"),
                ),
              ),
            ),
          ],
        );

      // COMPLETED
      case TripState.completed:
        return const SizedBox();
    }
  }
}

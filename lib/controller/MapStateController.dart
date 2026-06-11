// lib/controller/MapStateController.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/location/LocationService.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/MapService.dart';
import 'package:driver_app/state/MapDataState.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';

final mapStateControllerProvider = StateNotifierProvider<MapStateController, MapDataState>((ref) {
  return MapStateController(ref);
});

class MapStateController extends StateNotifier<MapDataState> {
  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;
  GoogleMapController? googleMapController;

  MapStateController(this._ref) : super(MapDataState()) {
    _listenToLocation();
  }

  void _listenToLocation() async {
    bool hasPermission = await LocationService.handlePermission();
    if (!mounted) return;
    
    state = state.copyWith(hasPermission: hasPermission, isCheckingPermission: false);
    if (!hasPermission) return;

    _positionSubscription = LocationService.getLiveLocation().listen((Position position) async {
      if (!mounted) return;

      final oldPos = state.currentPos;
      final latLng = LatLng(position.latitude, position.longitude);
      
      // Calculate heading angle dynamically between old and new points
      double bearing = state.bearing;
      if (oldPos != null) {
        bearing = _calculateBearing(oldPos, latLng);
      }

      state = state.copyWith(currentPos: latLng, bearing: bearing);
      AppStateService.setCurrentDriverLocation(latLng);

      // 🎥 TRACKING CAMERA: Always centers and follows driver smoothly
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 16.5, tilt: 0, bearing: 0),
        ),
      );

      // Send telemetry updates to backend
      final driverId = _ref.read(driverControllerProvider)?.driverId;
      if (driverId != null) {
        DriverCurrentLocationApiService.updateLocation(
          driverId: driverId,
          location: latLng,
        ).catchError((_) {});
      }

      // 🔄 CONTINUOUS UPDATE: Every time the location ticks, redraw the line from current location
      await updateRoute();
    });
  }

  Future<void> updateRoute() async {
    if (!mounted) return;

    final trip = _ref.read(tripControllerProvider);
    final currentPos = state.currentPos;

    // Clear polylines instantly if driver is offline/idle
    if (trip == null || currentPos == null) {
      state = state.copyWith(polylines: <Polyline>{});
      return;
    }

    LatLng? destination;
    
    // Choose destination targets based on precise active state
    if (trip.tripState == TripState.accepted || trip.tripState == TripState.onPickup) {
      destination = LatLng(trip.pickupAddress.latitude, trip.pickupAddress.longitude);
    } else if (trip.tripState == TripState.arrived || trip.tripState == TripState.onTrip) {
      destination = LatLng(trip.dropAddress.latitude, trip.dropAddress.longitude);
    } else {
      state = state.copyWith(polylines: <Polyline>{});
      return;
    }

    // Call map engine to fetch lines from moving driver -> static target point
    final routeData = await MapService.getRoutePoints(origin: currentPos, destination: destination);
    if (!mounted || routeData == null) return;

    state = state.copyWith(
      distanceText: routeData.distance,
      durationText: routeData.duration,
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: routeData.points, // Dynamic List<LatLng> path
          width: 5,
          color: const Color(0xFF1E3C72),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      },
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * pi / 180;
    double lng1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lng2 = end.longitude * pi / 180;
    double dLng = lng2 - lng1;
    double y = sin(dLng) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    double bearing = atan2(y, x);
    return (bearing * 180 / pi + 360) % 360;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    googleMapController?.dispose();
    super.dispose();
  }
}
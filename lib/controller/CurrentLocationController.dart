import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/location/LocationService.dart';
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';
import 'package:driver_app/state/DriverState.dart';

final currentLocationControllerProvider = StateNotifierProvider<CurrentLocationController, LatLng?>((ref) {
  return CurrentLocationController(ref);
});

class CurrentLocationController extends StateNotifier<LatLng?> {
  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;

  CurrentLocationController(this._ref) : super(null);

  Future<void> startLocationTracking() async {
    if (_positionSubscription != null) return; 

    bool hasPermission = await LocationService.handlePermission();
    if (!hasPermission) {
      debugPrint("GPS Engine Aborted: Core permissions missing.");
      return;
    }

    _positionSubscription = LocationService.getLiveLocation().listen((Position position) async {
      final LatLng freshCoordinates = LatLng(position.latitude, position.longitude);
      state = freshCoordinates;

      final driverNotifier = _ref.read(driverControllerProvider);
      final currentDriver = driverNotifier.driver;
      
      if (currentDriver != null && 
          currentDriver.driverId != null && 
          currentDriver.driverState == DriverState.online) {
        
        await DriverCurrentLocationApiService.updateLocation(
          driverId: currentDriver.driverId!,
          location: freshCoordinates,
        ).catchError((_) {});
      }
    });
    debugPrint("Tracking Engine Stream tracking active.");
  }

  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    state = null;
    debugPrint("Tracking Engine Stream tracking halted.");
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}
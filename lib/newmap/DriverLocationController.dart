import 'dart:async'; // Required for Timer
import 'package:driver_app/newmap/DriverLocation.dart';
import 'package:driver_app/newmap/LocationService.dart';
import 'package:driver_app/newmap/LocationSyncService.dart'; // Import the new class
import 'package:driver_app/controller/DriverController.dart'; // Assuming this provides driverId
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLocationController extends StateNotifier<DriverLocation?> {
  Timer? _locationTimer; // Holds the reference to our background clock execution

  DriverLocationController() : super(null);

  
  Future<void> updateCurrentLocation() async {
    try {
      LatLng raw = await LocationService.getCurrentLocation();
      DriverLocation location = DriverLocation(
        latitude: raw.latitude, 
        longitude: raw.longitude
      );
      state = location;
    } catch (e) {
      print(e);
    }
  }

  
  void startPeriodicTracking(Ref ref) {
    _locationTimer?.cancel(); 

    
    _executeSyncCycle(ref);

    
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _executeSyncCycle(ref);
    });
  }

  
  Future<void> _executeSyncCycle(Ref ref) async {
    
    await updateCurrentLocation();

    
    final driverState= ref.read(driverControllerProvider);
    final currentDriver = driverState.driver;
    if (currentDriver != null && currentDriver.driverId != null && state != null) {
      await LocationSyncService.syncToBackend(
        driverId: currentDriver.driverId!,
        lat: state!.latitude,
        lng: state!.longitude,
      );
    }
  }

  
  void stopPeriodicTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void dispose() {
    _locationTimer?.cancel(); 
    super.dispose();
  }
}

final driverLocationControllerProvider = StateNotifierProvider<DriverLocationController, DriverLocation?>(
  (ref) => DriverLocationController(),
);

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';

class LocationSyncService {
  
  static Future<void> syncToBackend({required int driverId, required double lat, required double lng}) async {
    try {
      await DriverCurrentLocationApiService.updateLocation(
        driverId: driverId,
        location: LatLng(lat, lng),
      );
    } catch (e) {
      print("Backend sync failed: $e");
    }
  }
}
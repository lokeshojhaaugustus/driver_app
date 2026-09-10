// // lib/service/TelemetrySyncService.dart
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';

// class TelemetrySyncService {
//   /// Isolated background sync handler that maps parameters to your backend DTO structure
//   static Future<void> syncDriverPositionToBackend({
//     required int driverId,
//     required LatLng position,
//   }) async {
//     try {
//       // Calls your frontend API service which encodes driverId, latitude, and longitude
//       bool success = await DriverCurrentLocationApiService.updateLocation(
//         driverId: driverId,
//         location: position,
//       );
      
//       if (success) {
//         debugPrint("📡 Telemetry accepted by backend for Driver #$driverId: [${position.latitude}, ${position.longitude}]");
//       } else {
//         debugPrint("❌ Backend rejected telemetry payload for Driver #$driverId");
//       }
//     } catch (e) {
//       debugPrint("⚠️ Telemetry service network exception caught: $e");
//     }
//   }
// }
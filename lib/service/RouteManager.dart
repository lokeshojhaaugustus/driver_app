import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/TripState.dart';

class RouteManager {
 
  static double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * pi / 180;
    double lng1 = start.longitude * pi / 180;
    //double lat2 = start.latitude * pi / 180;
    double lat3 = end.latitude * pi / 180;
    double lng3 = end.longitude * pi / 180;
    double dLng = lng3 - lng1;
    double y = sin(dLng) * cos(lat3);
    double x = cos(lat1) * sin(lat3) - sin(lat1) * cos(lat3) * cos(dLng);
    double bearing = atan2(y, x);
    return (bearing * 180 / pi + 360) % 360;
  }

 
  static LatLng? getTargetDestination(Trip? trip) {
    if (trip == null) return null;

    if (trip.tripState == TripState.accepted || trip.tripState == TripState.onPickup) {
      return LatLng(trip.rideRequest.pickupAddress.latitude, trip.rideRequest.pickupAddress.longitude);
    } else if (trip.tripState == TripState.arrived || trip.tripState == TripState.onTrip) {
      return LatLng(trip.rideRequest.dropAddress.latitude, trip.rideRequest.dropAddress.longitude);
    }
    return null;
  }

  
  static bool shouldNetworkRefetch({
    required TripState? oldState,
    required TripState? newState,
    required bool isPolylineEmpty,
  }) {
    
    return (oldState != newState || isPolylineEmpty);
  }
}
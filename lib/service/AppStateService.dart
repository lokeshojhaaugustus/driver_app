import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppStateService {
  static void setCurrentDriver(Driver driver) {
    AppState.currentDriver = driver;
  }

  static Driver? getCurrentDriver() {
    return AppState.currentDriver;
  }

  static void clearCurrentDriver() {
    AppState.currentDriver = null;
  }

  static void setCurrentRideRequest(RideRequest rideRequest) {
    AppState.currentRideRequest = rideRequest;
  }

  static RideRequest? getCurrentRideRequest() {
    return AppState.currentRideRequest;
  }

  static void clearCurrentRideRequest() {
    AppState.currentRideRequest = null;
  }

  static void setCurrentTrip(Trip trip) {
    AppState.currentTrip = trip;
  }

  static Trip? getCurrentTrip() {
    return AppState.currentTrip;
  }

  static void clearCurrentTrip() {
    AppState.currentTrip = null;
  }

  static void setCurrentDriverLocation(LatLng latLng) {
    AppState.currentDriverLocation = latLng;
  }

  static LatLng? getCurrentDriverLocation() {
    return AppState.currentDriverLocation;
  }

  static void clearCurrentDriverLocation() {
    AppState.currentDriverLocation = null;
  }

  static void clearAppState() {
    AppState.currentDriver = null;
    AppState.currentRideRequest = null;
    AppState.currentTrip = null;
    AppState.currentDriverLocation = null;
  }
}

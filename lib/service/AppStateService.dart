import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppStateService {
  
  static void setCurrentDriverLocation(LatLng latLng) {
    AppState.currentDriverLocation = latLng;
  }

  static LatLng? getCurrentDriverLocation() {
    return AppState.currentDriverLocation;
  }

  static void clearCurrentDriverLocation() {
    AppState.currentDriverLocation = null;
  }

}

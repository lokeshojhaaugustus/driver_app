import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppState{

  static Driver? currentDriver;
  static RideRequest? currentRideRequest;
  static Trip? currentTrip;

  static LatLng? currentDriverLocation;


}
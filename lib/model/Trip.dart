import 'package:driver_app/model/Address.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/state/TripState.dart';

class Trip{

  final int tripId;
  final RideRequest rideRequest;
  final Driver driver;
  final Address pickupAddress;
  final String pickupLocation;

  final Address dropAddress;
  final String dropLocation;

  final int eta;
  final double amount;
  final double distance;

  TripState tripState;

  final DateTime startTime;
  DateTime? endTime;

  
  Trip({
    required this.tripId,
    required this.rideRequest,
    required this.driver,
    required this.pickupAddress,
    required this.pickupLocation,
    required this.dropAddress,
    required this.dropLocation,
    required this.eta,
    required this.amount,
    required this.distance,
    this.tripState=TripState.onPickup,
    required this.startTime,
    this.endTime,
  });

}
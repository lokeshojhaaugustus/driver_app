import 'package:driver_app/model/Address.dart';
import 'package:driver_app/state/RideRequestState.dart';

class RideRequest {
  final int rideRequestId;
  final Address pickupAddress;
  final String pickupLocation;
  final Address dropAddress;
  final String dropLocation;
  final int eta;
  final double amount;
  final double distance;

  RideRequestState rideRequestState;

  RideRequest({
    required this.rideRequestId,
    required this.pickupAddress,
    required this.pickupLocation,
    required this.dropAddress,
    required this.dropLocation,
    required this.eta,
    required this.amount,
    required this.distance,
    this.rideRequestState=RideRequestState.pending,
  });
}
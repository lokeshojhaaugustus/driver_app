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

  Map<String, dynamic> toJson(){
    return{
      "rideRequestId": rideRequestId,
      "pickupAddress": pickupAddress,
      "pickupLocation": pickupLocation,
      "dropAddress": dropAddress,
      "dropLocation": dropLocation,
      "eta": eta,
      "amount": amount,
      "distance": distance,
      "rideRequestState": rideRequestState
    };
  }

  factory RideRequest.fromJson(Map<String, dynamic> json){
    return RideRequest(
      rideRequestId: json["rideRequestId"], 
      pickupAddress: json["pickupAddress"], 
      pickupLocation: json["pickupLocation"], 
      dropAddress: json["dropAddress"], 
      dropLocation: json["dropLocation"], 
      eta: json["eta"], 
      amount: json["amount"], 
      distance: json["distance"],
      rideRequestState: json["rideRequestState"] 
    );
  }
}
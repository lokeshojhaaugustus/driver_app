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
      "pickupAddress": pickupAddress.toJson(),
      "pickupLocation": pickupLocation,
      "dropAddress": dropAddress.toJson(),
      "dropLocation": dropLocation,
      "eta": eta,
      "amount": amount,
      "distance": distance,
      "rideRequestState": rideRequestState.name
    };
  }

  factory RideRequest.fromJson(Map<String, dynamic> json){
    return RideRequest(
      rideRequestId: json["rideRequestId"], 
      pickupAddress: Address.fromJson(json["pickupAddress"]), 
      pickupLocation: json["pickupLocation"], 
      dropAddress: Address.fromJson(json["dropAddress"]), 
      dropLocation: json["dropLocation"], 
      eta: json["eta"], 
      amount: (json["amount"] as num).toDouble(), 
      distance: (json["distance"] as num).toDouble(),
      rideRequestState: RideRequestState.values.firstWhere(
        (state) => state.name==json["rideRequestState"]
      ),
    );
  }
}
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/state/TripState.dart';

class Trip{

  final int tripId;
  final RideRequest rideRequest;
  final Driver driver;
  // final Address pickupAddress;
  // final String pickupLocation;

  // final Address dropAddress;
  // final String dropLocation;

  // final int eta;
  // final double amount;
  // final double distance;

  TripState tripState;

  final DateTime? startTime;
  DateTime? endTime;

  
  Trip({
    required this.tripId,
    required this.rideRequest,
    required this.driver,
    // required this.pickupAddress,
    // required this.pickupLocation,
    // required this.dropAddress,
    // required this.dropLocation,
    // required this.eta,
    // required this.amount,
    // required this.distance,
    this.tripState=TripState.onPickup,
    this.startTime,
    this.endTime,
  });


  Map<String, dynamic> toJson(){
    return {
      "tripId": tripId,
      "rideRequest": rideRequest.toJson(),
      "driver": driver.toJson(),
      // "pickupAddress": pickupAddress.toJson(),
      // "pickupLocation": pickupLocation,
      // "dropAddress": dropAddress.toJson(),
      // "dropLocation": dropLocation,
      // "eta": eta,
      // "amount": amount,
      // "distance": distance,
      "tripState": tripState.name,
      "startTime": startTime?.toIso8601String(),
      "endTime": endTime?.toIso8601String()
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json){
    return Trip(
      tripId: json["tripId"], 
      rideRequest: RideRequest.fromJson(json["rideRequest"]), 
      driver: Driver.fromJson(json["driver"]), 
      // pickupAddress: Address.fromJson(json["pickupAddress"]), 
      // pickupLocation: json["pickupLocation"], 
      // dropAddress: Address.fromJson(json["dropAddress"]), 
      // dropLocation: json["dropLocation"], 
      // eta: json["eta"], 
      // amount: (json["amount"] as num).toDouble(), 
      // distance: (json["distance"] as num).toDouble(), 
      startTime: json["startTime"] != null ? DateTime.parse(json["startTime"]) : null,
      endTime: json["endTime"] != null ? DateTime.parse(json["endTime"]) : null,
      tripState: TripState.values.firstWhere((e) => e.name == json["tripState"])
    );
  }

}
import 'package:driver_app/data/AddressMockData.dart';
import 'package:driver_app/model/Address.dart';
import 'package:driver_app/model/RideRequest.dart';

class RideRequestMockData{

  static Address pick1=AddressMockData.addresses[0];
  static Address pick2=AddressMockData.addresses[1];

  static Address drop1=AddressMockData.addresses[3];
  static Address drop2=AddressMockData.addresses[4];

  static List<RideRequest> rideRequests=[
    RideRequest(
      rideRequestId: 1, 
      pickupAddress: pick1, 
      pickupLocation: "Delhi", 
      dropAddress: drop1, 
      dropLocation: "Mumbai", 
      eta: 200, 
      amount: 25000, 
      distance: 1000
    ),
    RideRequest(
      rideRequestId: 2, 
      pickupAddress: pick2, 
      pickupLocation: "Agra", 
      dropAddress: drop2, 
      dropLocation: "Hyderabad", 
      eta: 300, 
      amount: 20000, 
      distance: 1500
    ),
    RideRequest(
      rideRequestId: 3, 
      pickupAddress: pick1, 
      pickupLocation: pick1.city, 
      dropAddress: drop2, 
      dropLocation: drop2.city, 
      eta: 400, 
      amount: 30000, 
      distance: 1200
    )

  ];

}
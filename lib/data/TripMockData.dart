import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/data/RideRequestMockData.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';

class TripMockData{

  static RideRequest rideRequest1=RideRequestMockData.rideRequests[0];
  static RideRequest rideRequest2=RideRequestMockData.rideRequests[1];
  static RideRequest rideRequest3=RideRequestMockData.rideRequests[2];

  static List<Trip> trips=[
    Trip(
      tripId: 1, 
      rideRequest: rideRequest1, 
      driver: DriverMockData.drivers[0], 
      pickupAddress: rideRequest1.pickupAddress, 
      pickupLocation: rideRequest1.pickupLocation, 
      dropAddress: rideRequest1.dropAddress, 
      dropLocation: rideRequest1.dropLocation, 
      eta: rideRequest1.eta, 
      amount: rideRequest1.amount, 
      distance: rideRequest1.distance, 
      startTime: DateTime.now(),
    ),

    Trip(
      tripId: 2, 
      rideRequest: rideRequest2, 
      driver: DriverMockData.drivers[0], 
      pickupAddress: rideRequest2.pickupAddress, 
      pickupLocation: rideRequest2.pickupLocation, 
      dropAddress: rideRequest2.dropAddress, 
      dropLocation: rideRequest2.dropLocation, 
      eta: rideRequest2.eta, 
      amount: rideRequest2.amount, 
      distance: rideRequest2.distance, 
      startTime: DateTime.now(),
    ),

    Trip(
      tripId: 3, 
      rideRequest: rideRequest3, 
      driver: DriverMockData.drivers[0], 
      pickupAddress: rideRequest3.pickupAddress, 
      pickupLocation: rideRequest3.pickupLocation, 
      dropAddress: rideRequest3.dropAddress, 
      dropLocation: rideRequest3.dropLocation, 
      eta: rideRequest3.eta, 
      amount: rideRequest3.amount, 
      distance: rideRequest3.distance, 
      startTime: DateTime.now(),
    )
  ];
}
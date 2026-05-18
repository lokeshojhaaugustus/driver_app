import 'package:driver_app/apiservice/RideRequestApiService.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';

class RideRequestService{

  static Future<List<RideRequest>> getRideRequests(){
    final rideRequests= RideRequestApiService.getRideRequests();
    return rideRequests;
  }

  static Future<Trip?> acceptRideRequest(int rideRequestId, int driverId){
    final trip= RideRequestApiService.acceptRideRequest(rideRequestId, driverId);
    return trip;
  }

  static Future<bool> rejectRideRequest(int rideRequestId){
    final response= RideRequestApiService.rejectRideRequest(rideRequestId);
    return response;
  }

  static Future<bool> completeRideRequest(int rideRequestId){
    final response= RideRequestApiService.completeRideRequest(rideRequestId);
    return response;
  }
}
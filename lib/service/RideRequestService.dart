import 'package:driver_app/apiservice/RideRequestApiService.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/RideRequestState.dart';

class RideRequestService{

  static Future<List<RideRequest>> getRideRequests() async{
    final rideRequests= await RideRequestApiService.getRideRequests();
    return rideRequests;
  }

  static Future<Trip?> acceptRideRequest(int rideRequestId, int driverId) async{
    final trip= await RideRequestApiService.acceptRideRequest(rideRequestId, driverId);
    return trip;
  }

  static Future<bool> rejectRideRequest(int rideRequestId) async{
    final response= await RideRequestApiService.rejectRideRequest(rideRequestId);
    return response;
  }

  static Future<bool> completeRideRequest(int rideRequestId) async{
    final response= await RideRequestApiService.completeRideRequest(rideRequestId);
    return response;
  }

  static Future<bool> updateRideRequestState(int rideRequestId, RideRequestState newState) async{
    final response= await RideRequestApiService.updateRideRequestState(rideRequestId, newState);
    return response;
  }

  
}
import 'package:driver_app/apiservice/TripApiService.dart';
import 'package:driver_app/model/Trip.dart';

class TripService{

  static Future<bool> addTrip(Trip trip) async{
    final response= await TripApiService.addTrip(trip);
    return response;
  }

  static Future<bool> arrivedAtPickup(int tripId) async{
    final response= await TripApiService.arrivedAtPickup(tripId);
    return response;
  }

  static Future<bool> startTrip(int tripId) async {
    final response= await TripApiService.startTrip(tripId);
    return response;
  }

  static Future<bool> endTrip(int tripId) async {
    final response= await TripApiService.completeTrip(tripId);
    return response;
  }

  static Future<List<Trip>> getAllTripsByDriverId(int driverId) async{
    final response = await TripApiService.getAllTripsByDriverId(driverId);
    return response;
  }

  static Future<bool> startRide(int tripId) async {
    final response= await TripApiService.startRide(tripId);
    return response;
  }
}
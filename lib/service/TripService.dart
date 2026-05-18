import 'package:driver_app/apiservice/TripApiService.dart';
import 'package:driver_app/model/Trip.dart';

class TripService{

  static Future<bool> addTrip(Trip trip){
    final response= TripApiService.addTrip(trip);
    return response;
  }

  static Future<bool> arrivedAtPickup(int tripId){
    final response= TripApiService.arrivedAtPickup(tripId);
    return response;
  }

  static Future<bool> startTrip(int tripId) {
    final response= TripApiService.startTrip(tripId);
    return response;
  }

  static Future<bool> endTrip(int tripId) {
    final response= TripApiService.completeTrip(tripId);
    return response;
  }

  static Future<List<Trip>> getAllTripsByDriverId(int driverId){
    final response = TripApiService.getAllTripsByDriverId(driverId);
    return response;
  }
}
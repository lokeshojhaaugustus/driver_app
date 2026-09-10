import 'package:driver_app/controller/RideRequestController.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/service/RideRequestService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class TripController extends StateNotifier<Trip?> {

  final Ref ref;
  TripController(this.ref) : super(null);

  void setTrip(Trip trip){
    state = trip;
  }

  void clearTrip() {
    state = null;
  }

  Future<bool> startRide() async{
    final trip=state;
    if(trip==null){
      return false;
    }

    final success= await TripService.startRide(trip.tripId);

    if(!success){
      return false;
    }

    trip.tripState = TripState.onPickup;
    state=null;
    state=trip;
    return true;
  }

  Future<bool> arrivedAtPickup() async{
    final trip=state;
    if(trip==null){
      return false;
    }

    final success= await TripService.arrivedAtPickup(trip.tripId);

    if(!success){
      return false;
    }

    trip.tripState = TripState.arrived;
    state=null;
    state=trip;
    return true;
  }

  Future<bool> startTrip() async{
    final trip=state;
    if(trip==null){
      return false;
    }

    final success= await TripService.startTrip(trip.tripId);

    if(!success){
      return false;
    }

    trip.tripState = TripState.onTrip;
    state=null;
    state=trip;
    return true;
  }

  Future<String> executeCompleteTripPipeline() async {
    final trip = state;
    if (trip == null) {
      print("Trip state is null inside Controller!");
      return 'FAILED';
    }

    try {
      print("Attempting to complete trip #${trip.tripId} via API...");
      final success = await TripService.endTrip(trip.tripId);
      
      if (!success) {
        print(" TripService returned false (Generic Failure)");
        return 'FAILED';
      }

      print("Trip completed successfully on backend without document block.");
      await RideRequestService.completeRideRequest(trip.rideRequest.rideRequestId);
      ref.read(rideRequestControllerProvider.notifier).state = null;
      state = null; 
      return 'SUCCESS';

    } on HttpException catch (e) {
      print("Caught HttpException pipeline gatekeeper! Message: ${e.message}");
      if (e.message == 'DOCS_REQUIRED') {
        return 'DOCS_REQUIRED'; 
      }
      return 'FAILED';
    } catch (e) {
      print("Unknown Exception caught in pipeline: $e");
      return 'FAILED';
    }
  }

}

final tripControllerProvider = StateNotifierProvider<TripController, Trip?>(
        (ref) => TripController(ref),
  );
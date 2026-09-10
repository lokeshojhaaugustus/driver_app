import 'package:driver_app/controller/RideRequestController.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/service/RideRequestService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideRequestsController extends StateNotifier<List<RideRequest>> {
  final Ref ref;
  
  RideRequestsController(this.ref) : super([]);
  
  Future<void> loadRideRequests() async {
    final requests = await RideRequestService.getRideRequests();
    state = requests;
  }
  
  Future<void> refreshRideRequests() async {
    await loadRideRequests();
  }

  // INJECT NEW NOTIFICATION PACKET INSTANTLY
  void addRideRequest(RideRequest newRequest) {
    // Prevent adding duplicate list items if streams repeat
    if (state.any((item) => item.rideRequestId == newRequest.rideRequestId)) {
      return;
    }
    state = [newRequest, ...state];
  }

  Future<bool> acceptRideRequest(int rideRequestId, int driverId) async {
    final trip = await RideRequestService.acceptRideRequest(rideRequestId, driverId);
    if(trip == null){
      return false;
    }
    
    // fallback. If it's in the list, use it. 
    // If it's not (like opening via push notification), pull it directly from the backend's trip response!
    final rideRequest = state.any((item) => item.rideRequestId == rideRequestId)
        ? state.firstWhere((item) => item.rideRequestId == rideRequestId)
        : trip.rideRequest; // Assumes your Trip model has a rideRequest property
    
    if (rideRequest != null) {
      ref.read(rideRequestControllerProvider.notifier).setRideRequest(rideRequest);
    }
    
    ref.read(tripControllerProvider.notifier).setTrip(trip);
    
    // Remove from list if it happens to be there
    state = state.where((item) => item.rideRequestId != rideRequestId).toList();
    return true;
  }

  Future<bool> rejectRideRequest(int rideRequestId) async {
    final success = await RideRequestService.rejectRideRequest(rideRequestId);
    if(!success){
      return false;
    }
    
    state = state.where((item) => item.rideRequestId != rideRequestId).toList();
    return true;
  }

  void removeRideRequest(int rideRequestId) {
    state = state.where((item) => item.rideRequestId != rideRequestId).toList();
  }

  void clearRideRequests() {
    state = [];
  }
}

final rideRequestsControllerProvider = StateNotifierProvider<RideRequestsController, List<RideRequest>>(
  (ref) => RideRequestsController(ref),
);
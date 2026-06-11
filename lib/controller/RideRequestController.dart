import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/service/RideRequestService.dart';
import 'package:driver_app/state/RideRequestState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideRequestController extends StateNotifier<RideRequest?> {
  RideRequestController() : super(null);

  void setRideRequest(RideRequest rideRequest){
    state = rideRequest;
  }

  void clearRideRequest() {
    state = null;
  }

  Future<bool> changeRideRequestState(RideRequestState newState) async {
    final rideRequest = state;
    if (rideRequest == null || rideRequest.rideRequestId == null) {
      return false;
    }
    final success = await RideRequestService.updateRideRequestState(
      rideRequest.rideRequestId!,
      newState,
    );
    if(!success){
      return false;
    }
    rideRequest.rideRequestState = newState;
    state=null;
    state = rideRequest;
    return true;

  }
}

final rideRequestControllerProvider = StateNotifierProvider<RideRequestController, RideRequest?>(
        (ref) => RideRequestController(),
  );
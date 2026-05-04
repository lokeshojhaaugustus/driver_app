import 'package:driver_app/data/RideRequestMockData.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/state/RideRequestState.dart';

class RideRequestService{

  static List<RideRequest> getRideRequests(){
    return RideRequestMockData.rideRequests
      .where((r)=>r.rideRequestState==RideRequestState.pending)
      .toList();
  }

  static void acceptRide(RideRequest rideRequest){
    rideRequest.rideRequestState=RideRequestState.accepted;
  }

  static void rejectRide(RideRequest rideRequest){
    RideRequestMockData.rideRequests.remove(rideRequest);
  }
}
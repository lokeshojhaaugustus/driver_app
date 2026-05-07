import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/data/RideRequestMockData.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/riderequest/RideRequestCard.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:driver_app/service/RideRequestService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:flutter/material.dart';

class RideRequestList extends StatefulWidget {

  const RideRequestList({super.key});

  @override
  State<RideRequestList> createState() => _RideRequestListState();
}

class _RideRequestListState extends State<RideRequestList> {
  @override
  Widget build(BuildContext context) {

    final List<RideRequest> requests=RideRequestService.getRideRequests();

    if(requests.isEmpty){
      return Center(
        child: Text("No RideRequests"),
      );
    }

    return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context,index){
          final request=requests[index];
          return RideRequestCard(
            rideRequest: request, 
            onAccept: (){
              RideRequestService.acceptRide(request);
              final driver=DriverMockData.drivers.first;
              TripService.createTrip(request, driver);
              AppState.currentTrip=TripService.currentTrip;
              DriverStateManager().notifyListeners();
              setState(() {
                
              });
            }, 
            onReject: (){
              RideRequestService.rejectRide(request);
              setState(() {
                
              });
            }
          );
        }
      );
  }
}
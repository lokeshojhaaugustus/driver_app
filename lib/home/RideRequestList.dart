import 'package:driver_app/data/RideRequestMockData.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/riderequest/RideRequestCard.dart';
import 'package:flutter/material.dart';

class RideRequestList extends StatelessWidget {

  const RideRequestList({super.key});

  @override
  Widget build(BuildContext context) {

    final List<RideRequest> requests=RideRequestMockData.rideRequests;

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
            onAccept: (){}, 
            onReject: (){}
          );
        }
      );
  }
}
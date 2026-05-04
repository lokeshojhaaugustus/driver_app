import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideRouteMap.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'RideDetailsHeader.dart';
import 'RideActionButtons.dart';

class RideDetailsScreen extends StatelessWidget {

  final RideRequest rideRequest;

  const RideDetailsScreen({
    super.key,
    required this.rideRequest
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header + Card
          RideDetailsHeader(rideRequest: rideRequest),

          // Map section placeholder
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: RideRouteMap(
                pickup: LatLng(rideRequest.pickupAddress.latitude, rideRequest.pickupAddress.longitude), 
                drop: LatLng(rideRequest.dropAddress.latitude, rideRequest.dropAddress.longitude)
              )
            ),
          ),

          // Buttons
          const RideActionButtons(),
        ],
      ),
    );
  }
}
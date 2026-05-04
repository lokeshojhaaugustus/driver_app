import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsCard.dart';
import 'package:flutter/material.dart';

class RideDetailsHeader extends StatelessWidget {

  final RideRequest rideRequest;
  const RideDetailsHeader({
    super.key,
    required this.rideRequest
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back)
              ),
              Text(
                "Ride Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Ridedetailscard(rideRequest: rideRequest), 
        )
      ],
    );
  }
}
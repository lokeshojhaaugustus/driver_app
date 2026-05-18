import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsCard.dart';
import 'package:flutter/material.dart';

class RideDetailsHeader extends StatelessWidget {
  final RideRequest rideRequest;
  const RideDetailsHeader({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
              ),
              Text(
                "Ride Details",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Ridedetailscard(rideRequest: rideRequest),
        ),
      ],
    );
  }
}

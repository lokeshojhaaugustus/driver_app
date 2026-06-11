import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsCard.dart';
import 'package:flutter/material.dart';

class RideDetailsHeader extends StatelessWidget {
  final RideRequest rideRequest;
  const RideDetailsHeader({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // Premium deep background
      padding: const EdgeInsets.fromLTRB(4, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              const Text(
                "Trip Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Ridedetailscard(rideRequest: rideRequest),
          ),
        ],
      ),
    );
  }
}
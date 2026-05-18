import 'package:driver_app/model/RideRequest.dart';
import 'package:flutter/material.dart';

class Ridedetailscard extends StatelessWidget {
  final RideRequest rideRequest;

  const Ridedetailscard({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pickup: ${rideRequest.pickupLocation}"),
          SizedBox(height: 5),
          Text("Drop: ${rideRequest.dropLocation}"),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfo("Distance", "${rideRequest.distance}"),
              _buildInfo("Time", "${rideRequest.eta}"),
              _buildInfo("Earning", "${rideRequest.amount}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}

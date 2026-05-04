import 'package:driver_app/model/Trip.dart';
import 'package:flutter/material.dart';

class TripHistoryCard extends StatelessWidget {

  final Trip trip;

  const TripHistoryCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${trip.pickupLocation} → ${trip.dropLocation}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text("${trip.distance} km"),
              ],
            ),
          ),

          Text(
            "₹${trip.amount}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
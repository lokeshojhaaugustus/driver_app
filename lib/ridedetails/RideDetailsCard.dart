import 'package:driver_app/model/RideRequest.dart';
import 'package:flutter/material.dart';

class Ridedetailscard extends StatelessWidget {
  final RideRequest rideRequest;
  const Ridedetailscard({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850], // Dark card surface
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Address Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 14),
                  Container(width: 2, height: 32, color: Colors.grey[600]),
                  const Icon(Icons.location_on, color: Colors.orange, size: 16),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rideRequest.pickupLocation,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      rideRequest.dropLocation,
                      style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.white10),
          // Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric("Distance", "${rideRequest.distance} km", Icons.straighten),
              _buildMetric("Est. Time", "${rideRequest.eta} mins", Icons.schedule),
              _buildMetric("Fare", "\$${rideRequest.amount}", Icons.payments, isEarning: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String value, IconData icon, {bool isEarning = false}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: isEarning ? Colors.greenAccent : Colors.grey[400]),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isEarning ? Colors.greenAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
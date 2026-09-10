import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsScreen.dart'; // 1. Make sure to import your details screen here
import 'package:flutter/material.dart';

class RideRequestCard extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final RideRequest rideRequest;

  const RideRequestCard({
    super.key,
    required this.rideRequest,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RideDetailsScreen(
              rideRequest: rideRequest,
              
              onAccept: onAccept,
              onReject: onReject,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 14),
                    Container(width: 2, height: 24, color: Colors.grey.shade200),
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rideRequest.pickupLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        rideRequest.dropLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: Color(0xFFF1F1F1)),
            ),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatMetric(Icons.access_time_rounded, "${rideRequest.eta} mins"),
                _buildStatMetric(Icons.swap_calls_rounded, "${rideRequest.distance} Km"),
                Text(
                  "\$${rideRequest.amount}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
      
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: onReject,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("Decline", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A), // Uber-style modern black button
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("Accept Request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
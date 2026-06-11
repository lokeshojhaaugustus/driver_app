import 'package:driver_app/home/RideRequestList.dart';
import 'package:driver_app/map/MapSection.dart';
import 'package:flutter/material.dart';

class OnlineScreen extends StatelessWidget {
  final bool showRideRequests;

  const OnlineScreen({
    super.key,
    required this.showRideRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Section stays bound as the core base
        const Positioned.fill(
          child: MapSection(),
        ),

        // Bottom Requests Panel overlay configuration
        if (showRideRequests)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nearby Requests",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RideRequestList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
import 'package:driver_app/driverprofile/DriverStatCard.dart';
import 'package:driver_app/model/DriverStats.dart';
import 'package:driver_app/service/DriverStatsService.dart';
import 'package:flutter/material.dart';

class DriverStatsSection extends StatelessWidget {
  final int? driverId;

  const DriverStatsSection({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    if (driverId == null) {
      return const SizedBox();
    }

    return FutureBuilder<DriverStats?>(
      future: DriverStatsService.findDriverStats(driverId!),
      builder: (context, snapshot) {
        final stats = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          );
        }

        return _buildStats(stats);
      },
    );
  }

  Widget _buildStats(DriverStats? stats) {
    final totalTrips = stats == null ? "0" : stats.totalTrips.toString();
    final totalDistance = stats == null
        ? "0"
        : stats.totalDistance.toStringAsFixed(0);
    final totalEarning = stats == null
        ? "0"
        : stats.totalEarning.toStringAsFixed(0);
    final avgRating = stats == null ? "0" : stats.avgRating.toStringAsFixed(1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
        children: [
          DriverStatCard(
            icon: Icons.local_taxi,
            value: totalTrips,
            label: "Total Trips",
            themeColor: Colors.indigoAccent,
          ),
          DriverStatCard(
            icon: Icons.route,
            value: "$totalDistance Km",
            label: "Distance",
            themeColor: Colors.teal,
          ),
          DriverStatCard(
            icon: Icons.currency_rupee,
            value: totalEarning,
            label: "Earnings",
            themeColor: Colors.green,
          ),
          DriverStatCard(
            icon: Icons.star,
            value: avgRating,
            label: "Rating",
            themeColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}

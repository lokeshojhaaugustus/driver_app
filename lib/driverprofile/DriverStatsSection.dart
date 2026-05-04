import 'package:driver_app/driverprofile/DriverStatCard.dart';
import 'package:flutter/material.dart';

class DriverStatsSection extends StatelessWidget {
  const DriverStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.2,
        children: [
          DriverStatCard(icon: Icons.local_taxi, value: "128", lable: "Trips"),
          DriverStatCard(icon: Icons.route, value: "1200 Km", lable: "Kilometers"),
          DriverStatCard(icon: Icons.currency_rupee, value: "20000", lable: "Earnings"),
          DriverStatCard(icon: Icons.local_taxi, value: "4.5", lable: "Rating")
        ], 
      ),
    );
  }
}
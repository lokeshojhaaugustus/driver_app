import 'package:driver_app/data/DriverStatsMockData.dart';
import 'package:driver_app/data/TripMockData.dart';
import 'package:driver_app/history/HistoryScreen.dart';
import 'package:driver_app/model/DriverStats.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {

  //final DriverStats driverStats;
  //final List<Trip> trips;

  const HistoryCard({
    super.key,
    //required this.driverStats,
    //required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    List<Trip> driverTrips=TripService.getTripsByDriverId(1);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryScreen(
              driverStats: DriverStatsMockData.driverStats[0],
              trips: driverTrips,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            Icon(Icons.history_outlined),
            SizedBox(width: 10),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trip History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "View All Past Trips & Earnings"
                  )
                ],
              ),
            ),
      
            Icon(Icons.arrow_forward_outlined, size: 18,)
          ],
        ),
      ),
    );
  }
}
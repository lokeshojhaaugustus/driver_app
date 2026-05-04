import 'package:driver_app/history/TotalEarningCard.dart';
import 'package:driver_app/history/TripHistoryCard.dart';
import 'package:driver_app/model/DriverStats.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {

  final DriverStats driverStats;
  final List<Trip> trips;

  const HistoryScreen({
    super.key,
    required this.driverStats,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings"),
      ),
      body: Column(
        children: [
          TotalEarningCard(
            totalEarning: driverStats.totalEarning
          ),
          SizedBox(
            height:10
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index){
                return TripHistoryCard(
                  trip: trips[index],
                );
              }
            ) 
          )
        ],
      )
    );
  }
}
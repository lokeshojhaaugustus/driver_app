import 'package:driver_app/history/TotalEarningCard.dart';
import 'package:driver_app/history/TripHistoryCard.dart';
import 'package:driver_app/model/DriverStats.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/service/DriverStatsService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final int driverId;

  const HistoryScreen({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Earnings")),
      body: FutureBuilder<_HistoryData>(
        future: _loadHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;

          if (data == null) {
            return const Center(child: Text("Unable to load history"));
          }

          return Column(
            children: [
              TotalEarningCard(
                totalEarning: data.driverStats?.totalEarning ?? 0,
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: data.trips.length,
                  itemBuilder: (context, index) {
                    return TripHistoryCard(trip: data.trips[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<_HistoryData> _loadHistory() async {
    final stats = await DriverStatsService.findDriverStats(driverId);
    final trips = await TripService.getAllTripsByDriverId(driverId);
    return _HistoryData(driverStats: stats, trips: trips);
  }
}

class _HistoryData {
  final DriverStats? driverStats;
  final List<Trip> trips;

  _HistoryData({required this.driverStats, required this.trips});
}

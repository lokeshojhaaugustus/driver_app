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
      backgroundColor: const Color(0xFFF8FAFC), // Modern soft background tint
      appBar: AppBar(
        title: const Text(
          "Earnings History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1E3C72),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<_HistoryData>(
        future: _loadHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A5298))),
            );
          }

          final data = snapshot.data;

          if (data == null || data.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text("No trips logged yet", style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TotalEarningCard(
                totalEarning: data.driverStats?.totalEarning ?? 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 12.0, bottom: 8.0),
                child: Text(
                  "RECENT TRIPS (${data.trips.length})",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  physics: const BouncingScrollPhysics(),
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
import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/driverprofile/DriverDetailButton.dart';
import 'package:driver_app/driverprofile/DriverProfileHeader.dart';
import 'package:driver_app/driverprofile/DriverStatsSection.dart';
import 'package:driver_app/driverprofile/HistoryCard.dart';
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final driver=DriverMockData.drivers.first;
    return Scaffold(
      body: Column(
        children: [
          DriverProfileHeader(driver: driver),
          SizedBox(
            height: 10,
          ),
          DriverDetailButton(),
          SizedBox(
            height: 10,
          ),
          DriverStatsSection(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                HistoryCard()
              ],
            ) 
          )
        ],
      ),
    );
  }
}
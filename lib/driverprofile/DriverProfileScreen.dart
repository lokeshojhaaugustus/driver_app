import 'package:driver_app/driverprofile/DriverDetailButton.dart';
import 'package:driver_app/driverprofile/DriverProfileHeader.dart';
import 'package:driver_app/driverprofile/DriverStatsSection.dart';
import 'package:driver_app/driverprofile/HistoryCard.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final driver=AppStateService.getCurrentDriver();

    if(driver==null){
      return Scaffold(
        body: Center(
          child: Text("No Active Driver."),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          DriverProfileHeader(driver: driver),
          SizedBox(
            height: 10,
          ),
          DriverDetailButton(),
          // SizedBox(
          //   height: 10,
          // ),
          DriverStatsSection(driverId: driver.driverId),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                HistoryCard(driver: driver)
              ],
            ) 
          )
        ],
      ),
    );
  }
}
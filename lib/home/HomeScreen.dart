import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/home/HomeHeader.dart';
import 'package:driver_app/home/OnlineOfflineToggle.dart';
import 'package:driver_app/home/RideRequestList.dart';
import 'package:driver_app/map/MapSection.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Driver driver = DriverMockData.drivers.first;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DriverStateManager(),
      builder: (context, _) {
        final isOnline =
            DriverStateManager().state == DriverState.online;

        return Scaffold(
          body: Column(
            children: [
              HomeHeader(
                driver: driver,
                onProfileClick: () {
                  Navigator.of(context).pushNamed("/profile");
                },
              ),

              const SizedBox(height: 5),

              const OnlineOfflineToggle(),

              const SizedBox(height: 5),

              // MAP SECTION
              if (isOnline)
                const SizedBox(
                  height: 300,
                  child: MapSection(),
                )
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.7,
                  child: Center(
                    //child: Lottie.asset("assets/gif/internet.json"),
                    child: Text("Offline!")
                  ),
                ),

              const SizedBox(height: 5),

              // RIDE REQUEST LIST
              if (isOnline && AppState.currentTrip==null)
                const Expanded(
                  child: RideRequestList(),
                )
              else
                const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
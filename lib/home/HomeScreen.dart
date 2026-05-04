import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/home/HomeHeader.dart';
import 'package:driver_app/home/OnlineOfflineToggle.dart';
import 'package:driver_app/home/RideRequestList.dart';
import 'package:driver_app/map/MapSection.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Driver driver=DriverMockData.drivers.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeHeader(
            driver: driver, 
            onProfileClick: (){
              Navigator.of(context).pushNamed("/profile");
            }
          ),
          SizedBox(
            height:5,
          ),
          OnlineOfflineToggle(),
          SizedBox(
            height:5
          ),
          SizedBox(
            height:300,
            child: MapSection(),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: RideRequestList()
          )
        ],
      ),
    );
  }
}
import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/DriverStats.dart';

class DriverStatsMockData {

  static Driver driver1=DriverMockData.drivers[0];
  static Driver driver2=DriverMockData.drivers[1];

  static List<DriverStats> driverStats=[
    DriverStats(
      driver: driver1,
      totalTrips: 2,
      totalEarning: 50000,
      totalDistance: 6500,
      avgRating: 4.6,
      completedTrips: 2,
      cancelledTrips: 0 
    ),
    DriverStats(
      driver: driver2,
      totalTrips: 2,
      totalEarning: 50000,
      totalDistance: 6500,
      avgRating: 4.6,
      completedTrips: 2,
      cancelledTrips: 0 
    ),
  ];

}
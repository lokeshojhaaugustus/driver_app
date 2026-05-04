import 'package:driver_app/model/Driver.dart';

class DriverStats{

  final Driver driver;
  int totalTrips;
  double totalEarning;
  double totalDistance;
  double avgRating;
  int completedTrips;
  int cancelledTrips;

  DriverStats({
    required this.driver,
    required this.totalTrips,
    required this.totalEarning,
    required this.totalDistance,
    required this.avgRating,
    required this.completedTrips,
    required this.cancelledTrips
  });

}
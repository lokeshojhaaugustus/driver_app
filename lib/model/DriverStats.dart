import 'package:driver_app/model/Driver.dart';

class DriverStats{

  int? driverStatsId;
  final Driver driver;
  int totalTrips;
  double totalEarning;
  double totalDistance;
  double avgRating;
  int completedTrips;
  int cancelledTrips;

  DriverStats({
    this.driverStatsId,
    required this.driver,
    required this.totalTrips,
    required this.totalEarning,
    required this.totalDistance,
    required this.avgRating,
    required this.completedTrips,
    required this.cancelledTrips
  });

  Map<String, dynamic> toJson(){
    return {
      "driverStatsId": driverStatsId,
      "driver": driver.toJson(),
      "totalTrips": totalTrips,
      "totalEarning": totalEarning,
      "totalDistance": totalDistance,
      "avgRating": avgRating,
      "completedTrips": completedTrips,
      "cancelledTrips": cancelledTrips
    };
  }

  factory DriverStats.fromJson(Map<String, dynamic> json){
    return DriverStats(
      driverStatsId: json["driverStatsId"],
      driver: Driver.fromJson(json["driver"]), 
      totalTrips: json["totalTrips"], 
      totalEarning: json["totalEarning"], 
      totalDistance: json["totalDistance"], 
      avgRating: (json["avgRating"] as num).toDouble(), 
      completedTrips: json["completedTrips"], 
      cancelledTrips: json["cancelledTrips"]
    );
  }

}
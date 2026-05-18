import 'package:driver_app/apiservice/DriverStatsApiService.dart';
import 'package:driver_app/model/DriverStats.dart';

class DriverStatsService{

  static Future<bool> addDriverStats(DriverStats driverStats){
    final response= DriverStatsApiService.addDriverStats(driverStats);
    return response;
  }

  static Future<DriverStats?> findDriverStats(int driverId){
    final response= DriverStatsApiService.findDriverStats(driverId);
    return response;
  }

  static Future<List<DriverStats>> findAllDriverStats(){
    final response= DriverStatsApiService.findAllDriverStats();
    return response;
  }

  static Future<bool> updateDriverStats(int driverId, DriverStats driverStats){
    final response= DriverStatsApiService.updateDriverStats(driverId, driverStats);
    return response;
  }

}
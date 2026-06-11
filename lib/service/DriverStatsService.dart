import 'package:driver_app/apiservice/DriverStatsApiService.dart';
import 'package:driver_app/model/DriverStats.dart';

class DriverStatsService{

  static Future<bool> addDriverStats(DriverStats driverStats) async{
    final response= await DriverStatsApiService.addDriverStats(driverStats);
    return response;
  }

  static Future<DriverStats?> findDriverStats(int driverId) async{
    final response= await DriverStatsApiService.findDriverStats(driverId);
    return response;
  }

  static Future<List<DriverStats>> findAllDriverStats() async{
    final response= await DriverStatsApiService.findAllDriverStats();
    return response;
  }

  static Future<bool> updateDriverStats(int driverId, DriverStats driverStats) async{
    final response= await DriverStatsApiService.updateDriverStats(driverId, driverStats);
    return response;
  }

}
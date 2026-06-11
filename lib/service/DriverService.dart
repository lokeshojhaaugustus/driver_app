import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/apiservice/TripApiService.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/DriverState.dart';

class DriverService{

  static Future<int?> addDriver(Driver driver) async{
    final driverId= await DriverApiService.addDriver(driver);
    return driverId;
  }
  
  static Future<Driver?> find(int driverId) async{
    final driver= await DriverApiService.getDriverById(driverId);
    return driver;
  }

  static Future<List<Driver>> findAll() async{
    final response= DriverApiService.getDrivers();
    return response;
  }

  static Future<bool> updateDriverDetails(int driverId, Driver driver) async{
    final response= await DriverApiService.updateDriverDetails(driverId, driver);
    return response;
  }

  static Future<bool> updateDriverState(int driverId, DriverState driverState) async{
    final response= await DriverApiService.updateDriverState(driverId, driverState);
    return response;
  }

  static Future<Trip?> getCurrentTrip(int driverId) async{
    final trip= await TripApiService.getCurrentTrip(driverId);
    return trip;
  }
}
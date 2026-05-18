import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/state/DriverState.dart';

class DriverService{

  static Future<bool> addDriver(Driver driver){
    final isAdded= DriverApiService.addDriver(driver);
    return isAdded;
  }
  
  static Future<Driver?> find(int driverId){
    final driver= DriverApiService.getDriverById(driverId);
    return driver;
  }

  static Future<List<Driver>> findAll(){
    final response= DriverApiService.getDrivers();
    return response;
  }

  static Future<bool> updateDriverDetails(int driverId, Driver driver){
    final response= DriverApiService.updateDriverDetails(driverId, driver);
    return response;
  }

  static Future<bool> updateDriverState(int driverId, DriverState driverState){
    final response= DriverApiService.updateDriverState(driverId, driverState);
    return response;
  }
}
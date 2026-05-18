import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/apiservice/TripApiService.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/SharedPreferenceService.dart';

class SessionService{
  
  static Future<bool> restoreSession() async{
    final driverId= await SharedPreferenceService.getDriverId();
    if(driverId==null){
      return false;
    }

    final driver= await DriverApiService.getDriverById(driverId);
    if(driver==null){
      return false;
    }

    AppStateService.setCurrentDriver(driver);

    final trip= await TripApiService.getCurrentTrip(driverId);
    if(trip!=null){
      AppStateService.setCurrentTrip(trip);
      AppStateService.setCurrentRideRequest(trip.rideRequest);
    }

    return true;
  }

  static Future<void> clearSession() async{
    await SharedPreferenceService.removeDriverId();
    AppStateService.clearAppState();
  }
}
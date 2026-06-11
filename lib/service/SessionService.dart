import 'package:driver_app/apiservice/DriverDeviceTokenApiService.dart';
import 'package:driver_app/apiservice/TripApiService.dart';
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/controller/RideRequestController.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/provider/AppProvider.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:driver_app/service/SharedPreferenceService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionService{
  
  static Future<bool> restoreSession() async{
    final driverId= await SharedPreferenceService.getDriverId();
    if(driverId==null){
      return false;
    }

    final driver= await DriverService.find(driverId);
    if(driver==null){
      return false;
    }
    await DriverDeviceTokenApiService.setDeviceToken(driverId);
    appProviderContainer.read(driverControllerProvider.notifier).state = driver;
    await restoreDriverTrip(driverId);
    return true;
  }

  static Future<void> restoreDriverTrip(int driverId) async{
    final trip= await TripApiService.getCurrentTrip(driverId);
    if(trip!=null){
      appProviderContainer.read(tripControllerProvider.notifier).state = trip;
      appProviderContainer.read(rideRequestControllerProvider.notifier).state = trip.rideRequest;
    }
  }

  static Future<void> clearSession() async{
    await SharedPreferenceService.removeDriverId();
  }
}
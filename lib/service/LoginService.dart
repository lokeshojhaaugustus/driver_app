import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/apiservice/DriverDeviceTokenApiService.dart';
import 'package:driver_app/apiservice/LoginApiService.dart';
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/provider/AppProvider.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/service/SharedPreferenceService.dart';

class LoginService{

  static Future<Driver?> loginByDriverId(int driverId) async{
    final driver= await DriverApiService.getDriverById(driverId);
    return driver;
  }

  static Future<Driver?> login(LoginDto loginDto) async{
    final driver= await LoginApiService.login(loginDto);
    if(driver==null){
      return null;
    }
    await SharedPreferenceService.saveDriverId(driver.driverId!);
    await DriverDeviceTokenApiService.setDeviceToken(driver.driverId!);
    appProviderContainer.read(driverControllerProvider.notifier).state = driver;
    await SessionService.restoreDriverTrip(driver.driverId!);
    return driver;
  }



}
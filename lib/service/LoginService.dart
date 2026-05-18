import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/apiservice/LoginApiService.dart';
import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/model/Driver.dart';

class LoginService{

  static Future<Driver?> loginByDriverId(int driverId) async{
    final driver= DriverApiService.getDriverById(driverId);
    return driver;
  }

  static Future<Driver?> login(LoginDto loginDto){
    final driver= LoginApiService.login(loginDto);
    return driver;
  }



}
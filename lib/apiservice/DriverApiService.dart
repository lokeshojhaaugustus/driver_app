import 'dart:convert';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:http/http.dart' as http;

class DriverApiService {
  static Future<Driver?> getDriverById(int driverId) async {
    final response = await http.get(ApiConfig.uri("/driver/get/$driverId"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Driver.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<Driver>> getDrivers() async {
    final response = await http.get(ApiConfig.uri("/driver/get/all"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Driver.fromJson(item)).toList();
    }

    return [];
  }

  static Future<Driver?> login(LoginDto loginDto) async {
    final response = await http.post(
      ApiConfig.uri("/driver/login"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(loginDto.toJson()),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Driver.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<bool> addDriver(Driver driver) async {
    final response = await http.post(
      ApiConfig.uri("/driver/add"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(driver.toJson()),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> deleteDriver(int driverId) async {
    final response = await http.delete(ApiConfig.uri("/driver/delete/$driverId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> updateDriverState(
    int driverId,
    DriverState driverState,
  ) async {
    final response = await http.put(
      ApiConfig.uri("/driver/update/state/$driverId", {
        "driverState": driverState.name,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    final uppercaseRetry = await http.put(
      ApiConfig.uri("/driver/update/state/$driverId", {
        "driverState": driverState.name.toUpperCase(),
      }),
    );

    return uppercaseRetry.statusCode >= 200 && uppercaseRetry.statusCode < 300;
  }

  static Future<bool> updateDriverDetails(int driverId, Driver driver) async {
    final response = await http.put(
      ApiConfig.uri("/driver/update/details/$driverId"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(driver.toJson()),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

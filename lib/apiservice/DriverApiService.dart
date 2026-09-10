import 'dart:convert';
import 'dart:io';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DriverApiService {

  static Future<Driver?> getDriverById(int driverId) async {
    final response = await http.get(ApiConfig.uri("/driver/get/$driverId"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Driver.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  // static Future<List<Driver>> getDrivers() async {
  //   final response = await http.get(ApiConfig.uri("/driver/get/all"));

  //   if (response.statusCode == 200 && response.body.isNotEmpty) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((item) => Driver.fromJson(item)).toList();
  //   }
  //   return [];
  // }


  static Future<int?> addDriver(Driver driver, String? googleId) async {
    final Map<String,dynamic> body = driver.toJson();
    if(googleId!=null && googleId.isNotEmpty){
      body["googleId"]=googleId;
    }
    final response = await http.post(
      ApiConfig.uri("/driver/add"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return int.parse(response.body); // Reads the raw integer ID sent by Spring Boot
    }
    return null;
  }

  // static Future<bool> deleteDriver(int driverId) async {
  //   final response = await http.delete(ApiConfig.uri("/driver/delete/$driverId"));
  //   return response.statusCode >= 200 && response.statusCode < 300;
  // }

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
    return false;
  }

  static Future<bool> updateDriverDetails(int driverId, Driver driver) async {
    final response = await http.put(
      ApiConfig.uri("/driver/update/details/$driverId"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(driver.toJson()),
    );
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<String?> uploadImage(File imageFile, int driverId) async {
    try {
      final uri = ApiConfig.uri("/driver/upload/profilepic/$driverId");
      
      final request = http.MultipartRequest('POST', uri);

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: path.basename(imageFile.path),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body; 
      } else {
        print("Server error during image upload: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Network exception raised inside uploadImage service layer: $e");
      return null;
    }
  }
}

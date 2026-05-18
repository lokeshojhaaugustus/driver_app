import 'dart:convert';

import 'package:driver_app/model/DriverStats.dart';
import 'package:http/http.dart' as http;

class DriverStatsApiService{

  static Future<bool> addDriverStats(DriverStats driverStats) async{
    final response= await http.post(
      Uri.parse("http://10.0.2.2:8080/driverstats/add"),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(driverStats.toJson())
    );
    if(response.statusCode==200){
      return true;
    }
    return false;
  }

  static Future<DriverStats?> findDriverStats(int driverId) async{
    final response= await http.get(
      Uri.parse("http://10.0.2.2:8080/driverstats/get/$driverId"),
    );
    if(response.statusCode==200){
      return DriverStats.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<List<DriverStats>> findAllDriverStats() async{
    final response= await http.get(
      Uri.parse("http://10.0.2.2:8080/driverstats/get/all"),
    );
    if(response.statusCode==200){
      List<dynamic> jsonList= jsonDecode(response.body);
      List<DriverStats> driverStatsList= jsonList
          .map((json) => DriverStats.fromJson(json))
          .toList();
      return driverStatsList;
    }
    return [];
  }

  static Future<bool> updateDriverStats(int driverId, DriverStats driverStats) async{
    final response= await http.put(
      Uri.parse("http://10.0.2.2:8080/driverstats/update/$driverId"),
      headers: {
        "Content-Type" : "application/json"
      },
      body: jsonEncode(driverStats.toJson())
    );
    if(response.statusCode==200){
      return true;
    }
    return false;
  }




}
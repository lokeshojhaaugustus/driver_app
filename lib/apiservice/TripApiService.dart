import 'dart:convert';

import 'dart:io';
import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:http/http.dart' as http;

class TripApiService {
  static Future<Trip?> getTrip(int tripId) async {
    final response = await http.get(ApiConfig.uri("/trip/get/$tripId"));

    if (response.statusCode == 200 &&
        response.body.isNotEmpty &&
        response.body != "null") {
      return Trip.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<Trip>> getTrips() async {
    final response = await http.get(ApiConfig.uri("/trip/get/all"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Trip.fromJson(item)).toList();
    }

    return [];
  }

  static Future<Trip?> getCurrentTrip(int driverId) async {
    final response = await http.get(ApiConfig.uri("/trip/current/$driverId"));

    if (response.statusCode == 200 &&
        response.body.isNotEmpty &&
        response.body != "null") {
      return Trip.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<Trip>> getAllTripsByDriverId(int driverId) async {
    final response = await http.get(ApiConfig.uri("/trip/all/$driverId"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Trip.fromJson(item)).toList();
    }

    return [];
  }

  static Future<bool> deleteTrip(int tripId) async {
    final response = await http.delete(ApiConfig.uri("/trip/delete/$tripId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> addTrip(Trip trip) async {
    final response = await http.post(
      ApiConfig.uri("/trip/add"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(trip.toJson()),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> arrivedAtPickup(int tripId) async {
    final response = await http.put(ApiConfig.uri("/trip/arrived/$tripId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> startTrip(int tripId) async {
    final response = await http.put(ApiConfig.uri("/trip/start/$tripId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> completeTrip(int tripId) async {
    final response = await http.put(ApiConfig.uri("/trip/complete/$tripId"));
    
    print("🌐 Debug API Response: Status Code [${response.statusCode}] | Body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    }
    
    if (response.statusCode == 400) {
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody['error'] == 'DOCS_REQUIRED') {
          throw const HttpException('DOCS_REQUIRED'); 
        }
      } catch (e) {
        // If it's our target exception, rethrow it so the controller catches it
        if (e is HttpException) rethrow; 
      }
    }
    
    return false;
  }

  static Future<bool> startRide(int tripId) async {
    final response = await http.put(ApiConfig.uri("/trip/startride/$tripId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

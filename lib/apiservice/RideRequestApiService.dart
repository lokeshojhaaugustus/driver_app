import 'dart:convert';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:http/http.dart' as http;

class RideRequestApiService {
  static Future<RideRequest?> getRideRequest(int rideRequestId) async {
    final response = await http.get(
      ApiConfig.uri("/riderequest/get/$rideRequestId"),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return RideRequest.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<List<RideRequest>> getRideRequests() async {
    final response = await http.get(ApiConfig.uri("/riderequest/get/all"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List data = jsonDecode(response.body);
      return data.map((item) => RideRequest.fromJson(item)).toList();
    }

    return [];
  }

  static Future<List<RideRequest>> getPendingRideRequests() async {
    final response = await http.get(ApiConfig.uri("/riderequest/get/pending"));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List data = jsonDecode(response.body);
      return data.map((item) => RideRequest.fromJson(item)).toList();
    }

    return [];
  }

  static Future<bool> addRideRequest(RideRequest rideRequest) async {
    final response = await http.post(
      ApiConfig.uri("/riderequest/add"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode(rideRequest.toJson()),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<Trip?> acceptRideRequest(
    int rideRequestId,
    int driverId,
  ) async {
    final response = await http.put(
      ApiConfig.uri("/riderequest/accept/$rideRequestId/$driverId"),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Trip.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<bool> rejectRideRequest(int rideRequestId) async {
    final response = await http.put(ApiConfig.uri("/riderequest/reject/$rideRequestId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<bool> completeRideRequest(int rideRequestId) async {
    final response = await http.put(ApiConfig.uri("/riderequest/complete/$rideRequestId"));
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

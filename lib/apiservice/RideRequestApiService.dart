import 'dart:convert';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/RideRequestState.dart';
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

  static Future<RideRequest?> fetchRideById(int id) async {
    final response = await http.get(ApiConfig.uri("/riderequest/get/$id")); // Your backend endpoint

    if (response.statusCode == 200) {
      return RideRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load ride request from server");
    }
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

    print("status code ::::: ${response.statusCode}");
    print("response body ::::: ${response.body}");

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      //print("accept ride request ::::: ${response.body}");
      final decodedJson = jsonDecode(response.body);
      print("decoded json ::::: $decodedJson");
      final trip = Trip.fromJson(decodedJson);
      print("trip ::::: ${trip.tripId}");
      return trip;
      //return Trip.fromJson(jsonDecode(response.body));
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

  static Future<bool> updateRideRequestState(int rideRequestId, RideRequestState newState) async {
    final response = await http.put(
      ApiConfig.uri("/riderequest/update/state/$rideRequestId", {
        "rideRequestState": newState.name,
      }),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

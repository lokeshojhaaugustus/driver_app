import 'dart:convert';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DriverCurrentLocationApiService {
  static Future<LatLng?> getDriverLocation(int driverId) async {
    final response = await http.get(
      ApiConfig.uri("/driver/location/$driverId"),
    );

    if (response.statusCode == 200 &&
        response.body.isNotEmpty &&
        response.body != "null") {
      final data = jsonDecode(response.body);
      return LatLng(_toDouble(data["latitude"]), _toDouble(data["longitude"]));
    }

    return null;
  }

  static Future<bool> updateLocation({
    required int driverId,
    required LatLng location,
  }) async {
    final response = await http.put(
      ApiConfig.uri("/driver/location/update"),
      headers: ApiConfig.jsonHeaders,
      body: jsonEncode({
        "driverId": driverId,
        "latitude": location.latitude,
        "longitude": location.longitude,
      }),
    );
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? "") ?? 0;
  }
}

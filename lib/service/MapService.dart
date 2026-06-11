// lib/service/MapService.dart
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteData {
  final List<LatLng> points;
  final String distance;
  final String duration;

  RouteData({required this.points, required this.distance, required this.duration});
}

class MapService {
  static Future<RouteData?> getRoutePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    const apiKey = "AIzaSyA56YKW6VDfc0BBGdH80zxN2JY6R5nrgZk";

    final url = "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&mode=driving"
        "&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data["routes"].isEmpty) return null;

      final leg = data["routes"][0]["legs"][0];
      final distanceText = leg["distance"]["text"]; // e.g. "3.5 km"
      final durationText = leg["duration"]["text"]; // e.g. "12 mins"

      List steps = leg["steps"];
      List<LatLng> routePoints = [];

      for (var step in steps) {
        String encoded = step["polyline"]["points"];
        routePoints.addAll(decodePolyline(encoded));
      }

      return RouteData(
        points: routePoints,
        distance: distanceText,
        duration: durationText,
      );
    } catch (e) {
      return null;
    }
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0; result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }
}
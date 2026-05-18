import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RideRouteMap extends StatefulWidget {
  final LatLng pickup;
  final LatLng drop;

  const RideRouteMap({super.key, required this.pickup, required this.drop});

  @override
  State<RideRouteMap> createState() => _RideRouteMapState();
}

class _RideRouteMapState extends State<RideRouteMap> {
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    const apiKey = "AIzaSyA56YKW6VDfc0BBGdH80zxN2JY6R5nrgZk";

    final url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${widget.pickup.latitude},${widget.pickup.longitude}"
        "&destination=${widget.drop.latitude},${widget.drop.longitude}"
        "&mode=driving"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return;

    final data = jsonDecode(response.body);

    if (data["routes"].isEmpty) return;

    List steps = data["routes"][0]["legs"][0]["steps"];

    List<LatLng> routePoints = [];

    for (var step in steps) {
      String encoded = step["polyline"]["points"];
      routePoints.addAll(decodePolyline(encoded));
    }

    //List<LatLng> routePoints = decodePolyline(encoded);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints,
          width: 5,
          color: Colors.blue,
        ),
      );
    });
  }

  List<LatLng> decodePolyline(String encoded) {
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

      shift = 0;
      result = 0;

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

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: widget.pickup, zoom: 12),
      markers: {
        Marker(markerId: MarkerId("pickup"), position: widget.pickup),
        Marker(markerId: MarkerId("drop"), position: widget.drop),
      },
      polylines: _polylines,
    );
  }
}

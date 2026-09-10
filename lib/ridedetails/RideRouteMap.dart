// lib/location/RideRouteMap.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RideRouteMap extends StatefulWidget {
  final LatLng pickup;
  final LatLng drop;

  const RideRouteMap({
    super.key,
    required this.pickup,
    required this.drop,
  });

  @override
  State<RideRouteMap> createState() => _RideRouteMapState();
}

class _RideRouteMapState extends State<RideRouteMap> {
  GoogleMapController? _mapController;
  late Future<String> _mapStyleFuture;
  
  
  final Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  bool _isLoadingRoute = true;

 
  final String _googleApiKey = "AIzaSyA56YKW6VDfc0BBGdH80zxN2JY6R5nrgZk"; 

  @override
  void initState() {
    super.initState();
    _mapStyleFuture = rootBundle.loadString('assets/map_style.json');
  }


  Future<void> _fetchAndDrawRoute() async {
    if (widget.pickup.latitude == 0.0 || widget.drop.latitude == 0.0) {
      debugPrint("🛑 Error: Coordinates are empty.");
      return;
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
      'origin=${widget.pickup.latitude},${widget.pickup.longitude}'
      '&destination=${widget.drop.latitude},${widget.drop.longitude}'
      '&key=$_googleApiKey'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          _polylineCoordinates.clear();
          _polylines.clear();

          
          final legs = data['routes'][0]['legs'];
          if (legs != null && legs.isNotEmpty) {
            final steps = legs[0]['steps'];
            
            for (var step in steps) {
              final encodedPoints = step['polyline']['points'];
              
              _polylineCoordinates.addAll(_decodePolyline(encodedPoints));
            }
          }

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: const PolylineId("preview_ride_route"),
                color: const Color(0xFF1E3C72), // App thematic navy-blue
                width: 5,                       // Natural road line thickness
                points: _polylineCoordinates,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              ),
            );
            _isLoadingRoute = false;
          });

          _fitPointsInFrame();
        } else {
          debugPrint("Google Directions Error: ${data['status']}");
          setState(() => _isLoadingRoute = false);
        }
      }
    } catch (e) {
      debugPrint("Network Layer Execution Failure: $e");
      setState(() => _isLoadingRoute = false);
    }
  }

  
  List<LatLng> _decodePolyline(String encoded) {
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
    return FutureBuilder<String>(
      future: _mapStyleFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickup,
                zoom: 13,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              style: snapshot.data, 
              polylines: _polylines, // Renders the reactive set array
              markers: {
                Marker(
                  markerId: const MarkerId("pickup_pin"),
                  position: widget.pickup,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: const MarkerId("drop_pin"),
                  position: widget.drop,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
                
                
                _fetchAndDrawRoute();
              },
            ),
            if (_isLoadingRoute)
              const Positioned(
                top: 16,
                right: 16,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF1E3C72)),
                ),
              ),
          ],
        );
      },
    );
  }

  void _fitPointsInFrame() {
    if (_mapController == null || _polylineCoordinates.isEmpty) return;

    double minLat = _polylineCoordinates.first.latitude;
    double minLng = _polylineCoordinates.first.longitude;
    double maxLat = _polylineCoordinates.first.latitude;
    double maxLng = _polylineCoordinates.first.longitude;

    for (var point in _polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
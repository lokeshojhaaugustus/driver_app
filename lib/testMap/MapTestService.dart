import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapTestService {
  final String  apiKey="AIzaSyA56YKW6VDfc0BBGdH80zxN2JY6R5nrgZk";

  static Future<LatLng> getCurrentLatLng() async {
    Position position = await getCurrentLocation();
    return LatLng(position.latitude, position.longitude);
  }

  static Future<Position> getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location service is turned off. Please turn it on.");
    }

    permission= await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission= await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        return Future.error("Location permission denied by the user.");
      }
    }

    if(permission==LocationPermission.deniedForever){
      return Future.error("Location permission denied forever. Please enable it.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy:  LocationAccuracy.high
    );
  }

  Future<Polyline> drawRoadPath({
    required LatLng destination,
    required String polylineId
  }) async {
    try{
      Position position = await getCurrentLocation();
      LatLng origin = LatLng(position.latitude, position.longitude);

      final String url = 
          "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${origin.latitude},${origin.longitude}"
          "&destination=${destination.latitude},${destination.longitude}"
          "&key=$apiKey";
      
      final response= await http.get(Uri.parse(url));

      if(response.statusCode==200){
        final Map<String, dynamic> data = json.decode(response.body);

        if(data["status"]=="OK"){
          List<LatLng> detailedCooardinates = [];

          var legs= data["routes"][0]["legs"] as List;
          for(var leg in legs){
            var steps=leg["steps"] as List;
            for(var step in steps){
              String stepPolyline= step["polyline"]["points"];
              detailedCooardinates.addAll(decodePolyline(stepPolyline));
            }
          }

          return Polyline(
            polylineId: PolylineId(polylineId),
            points: detailedCooardinates,
            color: const Color(0xFF1E3C72),
            width: 5,
            geodesic: true,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round
          );
        }
        else{
          return Future.error("Google Maps Error: ${data['status']} - ${data['error_message'] ?? 'No route found'}");
        }
      }
      else{
        return Future.error("failed to connect to Google Api.");
      }

    }
    catch(e){
      debugPrint("Error in drawing the road route: $e");
      rethrow;
    }
  }

  static List<LatLng> decodePolyline(String encoded){
    List<LatLng> poly= [];
    int index=0, len= encoded.length;
    int lat=0, lng=0;

    while(index < len){
      int b, shift=0, result=0;
      do{
        b= encoded.codeUnitAt(index++)-63;
        result |= (b & 0x1f) << shift;
        shift +=5;
      }while(b >= 0x20);
      int dlat = ((result &1) !=0 ? ~(result >> 1) : (result >> 1));
      lat+=dlat;

      shift =0;
      result=0;
      do{
        b=encoded.codeUnitAt(index++)-63;
        result |= (b & 0x1f) << shift;
        shift +=5;
      }while(b>= 0x20);
      int dlng= ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng+= dlng;

      poly.add(LatLng(lat/1E5, lng/1E5));
    }
    return poly;
  }

  Future<Polyline> drawStraightPath({ 
    required LatLng destination,
    required String polylineId,
  }) async {
    try{
      Position position = await getCurrentLocation();
      LatLng origin= LatLng(position.latitude, position.longitude);
      return Polyline(
        polylineId: PolylineId(polylineId),
        points: [origin, destination],
        color: Color(0xFF1E3C72),
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
    }
    catch(e){
      debugPrint("Error in drawing route: $e");
      rethrow;
    }
  }
}
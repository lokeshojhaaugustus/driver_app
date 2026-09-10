import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService{

  static Future<LatLng> getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled= await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return const LatLng(0.0, 0.0);

    }

    locationPermission= await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied){
      locationPermission= await Geolocator.requestPermission();
      if(locationPermission== LocationPermission.denied){
        return const LatLng(0.0, 0.0);
      }
    }

    if(locationPermission== LocationPermission.deniedForever){
      return const LatLng(0.0, 0.0);
    }

    Position position= await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    return LatLng(position.latitude, position.longitude);

  }
}
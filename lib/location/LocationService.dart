import 'package:geolocator/geolocator.dart';

class LocationService{

  static Future<bool> handlePermission() async {

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  static Stream<Position> getLiveLocation(){
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )
    );
  }

}
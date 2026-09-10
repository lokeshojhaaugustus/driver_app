import 'dart:async';
import 'dart:math' as math;
import 'package:driver_app/testMap/MapTestRouteState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'MapTestService.dart';

final mapTestRouteControllerProvider = AutoDisposeNotifierProvider<MapTestRouteController, MapTestRouteState>((){
  return MapTestRouteController();
});

class MapTestRouteController extends AutoDisposeNotifier<MapTestRouteState>{
  final MapTestService mapTestService= MapTestService();
  StreamSubscription<Position>? _locationSubscription;

  List<LatLng> _currentRoutePoints = [];

  @override
  MapTestRouteState build(){

    ref.onDispose((){
      _locationSubscription?.cancel();
    });
    return MapTestRouteState(isLoading: true);
  }

  Future<void> fetchRouteTo(LatLng destination, String polylineId) async{
    state= state.copyWith(isLoading: true, errorMessage: null);
    try{
      Polyline polyline = await mapTestService.drawRoadPath(
        destination: destination, 
        polylineId: polylineId
      );

      _currentRoutePoints = List.from(polyline.points);

      state = state.copyWith(
        polylines: {polyline},
        isLoading: false,
      );

      _startLiveTracking();
    }
    catch(e){
      state= state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _startLiveTracking() {
    _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((Position position){
      final LatLng driverLatLng = LatLng(position.latitude, position.longitude);
      print("LIVE GPS TICK: Lat: ${position.latitude}, Lng: ${position.longitude}");

      _trimTraveledPath(driverLatLng);

      state= state.copyWith(
        driverLocation: LatLng(position.latitude, position.longitude) ,
        heading: position.heading,
      );
    }, onError: (e){
      state= state.copyWith(
        errorMessage: e.toString()
      );
    });
  }

  void _trimTraveledPath(LatLng driverPos){
    if(_currentRoutePoints.isEmpty){
      return;
    }

    int closestIndex=0;
    double shortestDistance= double.infinity;

    for(int i=0; i< _currentRoutePoints.length; i++){
      double distance = _calculateDistance(driverPos, _currentRoutePoints[i]);
      if(distance< shortestDistance){
        shortestDistance=distance;
        closestIndex=i;
      }
    }

    if(closestIndex>0 && shortestDistance<30.0){
      _currentRoutePoints= _currentRoutePoints.sublist(closestIndex);
      
      if(state.polylines.isNotEmpty){
        final existingPolyline = state.polylines.first;
        final Polyline updatedPolyline= existingPolyline.copyWith(
          pointsParam: _currentRoutePoints
        );
        state= state.copyWith(
          polylines: {updatedPolyline}
        );
      }
    }
  }

  double _calculateDistance(LatLng p1, LatLng p2){
    const double earthRadius = 6371000;
    double dLat= (p2.latitude - p1.latitude) * (math.pi/180.0);
    double dLng= (p2.longitude - p1.longitude) * (math.pi/180.0);

    double a= math.sin(dLat/2)*math.sin(dLat/2)+
              math.cos(p1.latitude * (math.pi/180.0))*
              math.cos(p2.latitude * (math.pi/180.0))*
              math.sin(dLng/2)* math.sin(dLng/2);

    double c= 2 * math .atan2(math.sqrt(a), math.sqrt(1-a));
    return earthRadius*c;
  }

}
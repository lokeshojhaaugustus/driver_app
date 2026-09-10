import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestRouteState {

  final Set<Polyline> polylines;
  final bool isLoading;
  final LatLng? driverLocation;
  final double heading;
  final String? errorMessage;


  MapTestRouteState({
    this.polylines = const{},
    this.isLoading=true,
    this.driverLocation,
    this.heading=0.0,
    this.errorMessage,
  });

  MapTestRouteState copyWith({
    Set<Polyline>? polylines,
    bool? isLoading,
    LatLng? driverLocation,
    double? heading,
    String? errorMessage,
  }){
    return MapTestRouteState(
      polylines: polylines ?? this.polylines,
      isLoading: isLoading ?? this.isLoading,
      driverLocation: driverLocation ?? this.driverLocation,
      heading: heading ?? this.heading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }


}
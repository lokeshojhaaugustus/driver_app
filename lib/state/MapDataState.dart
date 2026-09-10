
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDataState {
  final bool isCheckingPermission;
  final bool hasPermission;
  final LatLng? currentPos;
  final Set<Polyline> polylines;
  final double bearing;
  final String distanceText;
  final String durationText;

  MapDataState({
    this.isCheckingPermission = true,
    this.hasPermission = false,
    this.currentPos,
    this.polylines = const {},
    this.bearing = 0.0,
    this.distanceText = "-- km",
    this.durationText = "-- mins",
  });

  MapDataState copyWith({
    bool? isCheckingPermission,
    bool? hasPermission,
    LatLng? currentPos,
    Set<Polyline>? polylines,
    double? bearing,
    String? distanceText,
    String? durationText,
  }) {
    return MapDataState(
      isCheckingPermission: isCheckingPermission ?? this.isCheckingPermission,
      hasPermission: hasPermission ?? this.hasPermission,
      currentPos: currentPos ?? this.currentPos,
      polylines: polylines ?? this.polylines,
      bearing: bearing ?? this.bearing,
      distanceText: distanceText ?? this.distanceText,
      durationText: durationText ?? this.durationText,
    );
  }
}
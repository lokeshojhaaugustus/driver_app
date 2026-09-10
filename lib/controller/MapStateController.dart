import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/location/LocationService.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/MapService.dart';
import 'package:driver_app/service/RouteManager.dart';
import 'package:driver_app/state/MapDataState.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:driver_app/apiservice/DriverCurrentLocationApiService.dart';
import 'package:driver_app/state/DriverState.dart';

final mapStateControllerProvider = StateNotifierProvider<MapStateController, MapDataState>((ref) {
  return MapStateController(ref);
});

class MapStateController extends StateNotifier<MapDataState> {
  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;
  GoogleMapController? googleMapController;
  TripState? _lastProcessedTripState;


  Timer? _cameraBounceTimer;
  bool isUserInteracting = false;
  double currentZoomLevel = 17.0;

  MapStateController(this._ref) : super(MapDataState()) {
    _startLiveTracking();
  }

  void _startLiveTracking() async {
    bool hasPermission = await LocationService.handlePermission();
    if (!mounted) return;
    
    state = state.copyWith(hasPermission: hasPermission, isCheckingPermission: false);
    if (!hasPermission) return;

  
    _positionSubscription = LocationService.getLiveLocation().listen((Position position) async {
      if (!mounted) return;

      final oldPos = state.currentPos;
      final latLng = LatLng(position.latitude, position.longitude);
      
      final currentTrip = _ref.read(tripControllerProvider);
      final currentTripState = currentTrip?.tripState;
      

      double bearing = state.bearing;
      if (oldPos != null) {
        bearing = RouteManager.calculateBearing(oldPos, latLng);
      }


      state = state.copyWith(currentPos: latLng, bearing: bearing);
      AppStateService.setCurrentDriverLocation(latLng);

      final bool isTravelling = currentTripState == TripState.onPickup || 
                               currentTripState == TripState.onTrip;

 
      if (isTravelling && googleMapController != null && !isUserInteracting) {
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: currentZoomLevel, tilt: 30.0, bearing: bearing),
          ),
        );
      } 
      else if (!isTravelling && googleMapController != null && !isUserInteracting) {
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: currentZoomLevel, tilt: 0.0, bearing: 0.0),
          ),
        );
      }

      if (isTravelling && state.polylines.isNotEmpty) {
        try {
          final activePolyline = state.polylines.firstWhere((p) => p.polylineId.value == "route");
          List<LatLng> remainingPoints = _trimPassedRoutePoints(activePolyline.points, latLng);

          state = state.copyWith(
            polylines: {
              activePolyline.copyWith(pointsParam: remainingPoints),
            },
          );
        } catch (e) {
          debugPrint("Local route trimming warning: $e");
        }
      }

     
      final driverNotifier = _ref.read(driverControllerProvider);
      final currentDriver = driverNotifier.driver;
      if (currentDriver != null && 
          currentDriver.driverId != null && 
          currentDriver.driverState == DriverState.online) {
        DriverCurrentLocationApiService.updateLocation(
          driverId: currentDriver.driverId!,
          location: latLng,
        ).catchError((_) {});
      }

      if (RouteManager.shouldNetworkRefetch(
        oldState: _lastProcessedTripState,
        newState: currentTripState,
        isPolylineEmpty: state.polylines.isEmpty,
      )) {
        _lastProcessedTripState = currentTripState;
        await updateRoute();
      }
    });
  }

  
  void handleUserMapInteraction() {
    isUserInteracting = true;
    _cameraBounceTimer?.cancel();
    
    _cameraBounceTimer = Timer(const Duration(seconds: 3), () {
      isUserInteracting = false;
      final currentPos = state.currentPos;
      final currentTrip = _ref.read(tripControllerProvider);
      
      if (currentPos != null && googleMapController != null) {
        final bool isTravelling = currentTrip?.tripState == TripState.onPickup || 
                                 currentTrip?.tripState == TripState.onTrip;
                                 
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentPos,
              zoom: currentZoomLevel,
              tilt: isTravelling ? 30.0 : 0.0,
              bearing: isTravelling ? state.bearing : 0.0,
            ),
          ),
        );
      }
    });
  }

  Future<void> updateRoute() async {
    if (!mounted) return;

    final trip = _ref.read(tripControllerProvider);
    final currentPos = state.currentPos;

    if (trip == null || currentPos == null) {
      state = state.copyWith(polylines: <Polyline>{}, distanceText: "-- km", durationText: "-- mins");
      return;
    }

    final destination = RouteManager.getTargetDestination(trip);
    if (destination == null) {
      state = state.copyWith(polylines: <Polyline>{});
      return;
    }

    final routeData = await MapService.getRoutePoints(origin: currentPos, destination: destination);
    if (!mounted || routeData == null) return;

    state = state.copyWith(
      distanceText: routeData.distance,
      durationText: routeData.duration,
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: routeData.points, 
          width: 5,
          color: const Color(0xFF1E3C72),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      },
    );
  }

  List<LatLng> _trimPassedRoutePoints(List<LatLng> originalPoints, LatLng currentPos) {
    if (originalPoints.length < 2) return originalPoints;
    int closestIndex = 0;
    double minDistance = double.maxFinite;

    for (int i = 0; i < originalPoints.length; i++) {
      double distance = _coordinateDistance(currentPos, originalPoints[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    return originalPoints.sublist(closestIndex);
  }

  double _coordinateDistance(LatLng p1, LatLng p2) {
    return (p1.latitude - p2.latitude).abs() + (p1.longitude - p2.longitude).abs();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _cameraBounceTimer?.cancel();
    googleMapController?.dispose();
    super.dispose();
  }
}
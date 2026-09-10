import 'dart:async';

import 'dart:math' as math;

import 'package:driver_app/testMap/MapTestRouteState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/testMap/MapTestRouteController.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapTestScreen extends ConsumerStatefulWidget {
  const MapTestScreen({super.key});

  @override
  ConsumerState<MapTestScreen> createState() => _MapTestScreenState();
}

class _MapTestScreenState extends ConsumerState<MapTestScreen> with TickerProviderStateMixin {
  Set<Marker> _markers={};
  BitmapDescriptor? _truckIcon;
  static const LatLng _destinationPoint = LatLng(30.316495, 78.032192);   

  GoogleMapController? _mapController;
  bool _isUserInteracting= false;
  Timer? _recenterTimer;

  AnimationController? _movementController;
  LatLng? _previousGlidedLocation;
  LatLng? _targetGlidedLocation;
  double _previousHeading=0.0;
  double _targetHeading=0.0;

  void _moveCameraToPosition(LatLng position, double bearing){
    if(_mapController==null || _isUserInteracting){
      return;
    }

    final double offsetDistance = 0.0018;
    final double bearingInRadius = bearing * (math.pi / 180);

    final double offsetLat= position.latitude + (offsetDistance * math.cos(bearingInRadius));
    final double offsetLng= position.longitude + (offsetDistance * math.sin(bearingInRadius));
    final LatLng cameraTarget = LatLng(offsetLat, offsetLng);

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: cameraTarget, 
          zoom: 17.0,
          tilt: 45,
          bearing: bearing,
        ),
      ),
    );
  }



  void _startRecenterTimer(){
    _recenterTimer?.cancel();
    _recenterTimer = Timer(const Duration(seconds: 3),(){
      if(mounted){
        setState(() {
          _isUserInteracting=false;
        });
        final routeState= ref.read(mapTestRouteControllerProvider);
        if(routeState.driverLocation!=null){
          _moveCameraToPosition(
            routeState.driverLocation!, 
            routeState.heading,
          );
        }
      }
    });
  }
  

  @override
  void initState() {
    super.initState();
    _loadCustomTruckIcon();

    _movementController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    Future.microtask(() =>
      ref.read(mapTestRouteControllerProvider.notifier).fetchRouteTo(_destinationPoint, "live_route")
    );
  }

  @override
  void dispose() {
    _recenterTimer?.cancel();
    _movementController?.dispose(); 
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCustomTruckIcon() async {
    try{
      final BitmapDescriptor truckIcon = await getBytesFromAsset('assets/img/truck_icon.png', 150);
      setState(() {
        _truckIcon = truckIcon;
      });
      _updateDriverMarkerPositoin();
    } catch (e) {
      print("Error loading truck icon: $e");
    }
  }

  void _renderMarkerAt(LatLng position, double heading){
    setState(() {
      _markers ={
        Marker(
          markerId: const MarkerId("driver_marker"),
          position: position,
          icon: _truckIcon ?? BitmapDescriptor.defaultMarker,
          anchor: const Offset(0.5, 0.5),
          rotation: heading,
          flat: true 
        ),
      };
    });
  }

  void _updateDriverMarkerPositoin() {
    final routeState = ref.read(mapTestRouteControllerProvider);
    
    if(routeState.driverLocation!=null){
      if(_previousGlidedLocation==null){
        _previousGlidedLocation=routeState.driverLocation;
        _targetGlidedLocation= routeState.driverLocation;
        _previousHeading=routeState.heading;
        _targetHeading=routeState.heading;

        _renderMarkerAt(_previousGlidedLocation!, _previousHeading);
        _moveCameraToPosition(_previousGlidedLocation!, _previousHeading);
        return;
      }

      _previousGlidedLocation= _targetGlidedLocation;
      _targetGlidedLocation= routeState.driverLocation;
      _previousHeading= _targetHeading;
      _targetHeading = routeState.heading;

      _movementController?.reset();

      final Animation<double> curve = CurvedAnimation(
        parent: _movementController!, 
        curve: Curves.linear
      );

      _movementController!.addListener((){
        final double t = curve.value;

        final double currentLat= _previousGlidedLocation!.latitude +
                                (_targetGlidedLocation!.latitude - _previousGlidedLocation!.latitude) * t;
        final double currentLng = _previousGlidedLocation!.longitude +
                                (_targetGlidedLocation!.longitude - _previousGlidedLocation!.longitude) *t;
        
        final double currentHeading = _previousHeading + (_targetHeading - _previousHeading) * t;

        final LatLng intermediateLocation = LatLng(currentLat, currentLng);

        _renderMarkerAt(intermediateLocation, currentHeading);
        _moveCameraToPosition(intermediateLocation, currentHeading);
      });
      _movementController!.forward();
    }
    else if(routeState.polylines.isNotEmpty){
      final firstPolyline= routeState.polylines.first;
      if(firstPolyline.points.isNotEmpty){
        final startPos = firstPolyline.points.first;
        _renderMarkerAt(startPos, routeState.heading);
        _moveCameraToPosition(startPos, routeState.heading);
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    
    final routeState = ref.watch(mapTestRouteControllerProvider);
    final double mapSize = MediaQuery.of(context).size.width;
    //LatLng currentLatLng = await MapTestService.getCurrentLatLng();

    if(routeState.isLoading || routeState.driverLocation==null){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    
    ref.listen<MapTestRouteState>(mapTestRouteControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.redAccent),
        );
      }
      _updateDriverMarkerPositoin();
    });

    LatLng initialFocus= routeState.driverLocation?? _destinationPoint;
    final double offsetDistance = 0.0018;
    final double bearingInRadians = routeState.heading * (math.pi / 180.0);
    initialFocus = LatLng(
      routeState.driverLocation!.latitude + (offsetDistance * math.cos(bearingInRadians)),
      routeState.driverLocation!.longitude + (offsetDistance * math.sin(bearingInRadians)),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Riverpod Map Architecture"),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: (routeState.isLoading || routeState.driverLocation == null) 
          ? const CircularProgressIndicator() 
          : Container(
              width: mapSize,
              height: mapSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialFocus, 
                    zoom: 17.5,
                    tilt: 45.0,
                    bearing: routeState.heading,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: routeState.polylines, 
                  myLocationEnabled: true, 
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,

                  onCameraMoveStarted: (){
                    _recenterTimer?.cancel();
                    setState(() {
                      _isUserInteracting=true;
                    });
                  },
                
                  onCameraIdle: (){
                    if(_isUserInteracting){
                      _startRecenterTimer();
                    }
                  },
                ),
              ),
            ),
      ),
    );
  }
}


Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(), 
    targetWidth: width,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  
  final Uint8List markerAsBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
  
  return BitmapDescriptor.fromBytes(markerAsBytes);
}
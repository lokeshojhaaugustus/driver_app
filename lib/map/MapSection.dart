import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:driver_app/home/TripUploadScreen.dart';
import 'package:driver_app/service/RouteManager.dart';

class MapSection extends ConsumerStatefulWidget {
  const MapSection({super.key});

  @override
  ConsumerState<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends ConsumerState<MapSection> with TickerProviderStateMixin {

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _currentRoutePoints = [];
  

  bool _isLoading = true;
  String? _errorMessage;
  LatLng? _rawDriverLocation;
  double _currentHeading = 0.0;
  

  bool _isUserInteracting = false;
  Timer? _recenterTimer;


  AnimationController? _movementController;
  LatLng? _previousGlidedLocation;
  LatLng? _targetGlidedLocation;
  double _previousHeading = 0.0;
  double _targetHeading = 0.0;


  BitmapDescriptor? _truckIcon;
  BitmapDescriptor? _customArrowIcon; // 👈 Guarantees heading pointer displays perfectly 100% of the time!
  final String _apiKey = "AIzaSyA56YKW6VDfc0BBGdH80zxN2JY6R5nrgZk";
  int? _lastProcessedTripId;
  TripState? _lastProcessedTripState;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerAssets();

    _movementController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _checkPermissionsAndStartTracking();
  }

  @override
  void dispose() {
    _recenterTimer?.cancel();
    _movementController?.dispose();
    _mapController?.dispose();
    super.dispose();
  }


  Future<void> _loadCustomMarkerAssets() async {
    try {

      final ByteData truckData = await rootBundle.load('assets/img/truck_icon.png');
      final ui.Codec truckCodec = await ui.instantiateImageCodec(
        truckData.buffer.asUint8List(),
        targetWidth: 150,
      );
      final ui.FrameInfo truckFrame = await truckCodec.getNextFrame();
      final ByteData? truckBytes = await truckFrame.image.toByteData(format: ui.ImageByteFormat.png);
      
      if (truckBytes != null && mounted) {
        setState(() {
          _truckIcon = BitmapDescriptor.fromBytes(truckBytes.buffer.asUint8List());
        });
      }

      
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      const double size = 80.0;
      
      final Paint arrowPaint = Paint()
        ..color = const ui.Color(0xFF2196F3) // Electric navigation blue layout color profile
        ..style = PaintingStyle.fill;

      final Path path = Path();
      path.moveTo(size / 2, 0); 
      path.lineTo(size * 0.8, size * 0.8);
      path.lineTo(size / 2, size * 0.6); 
      path.lineTo(size * 0.2, size * 0.8);
      path.close();

      canvas.drawPath(path, arrowPaint);
      
      final ui.Image arrowImg = await recorder.endRecording().toImage(size.toInt(), size.toInt());
      final ByteData? arrowBytes = await arrowImg.toByteData(format: ui.ImageByteFormat.png);
      
      if (arrowBytes != null && mounted) {
        setState(() {
          _customArrowIcon = BitmapDescriptor.fromBytes(arrowBytes.buffer.asUint8List());
        });
      }
    } catch (e) {
      debugPrint("Marker setup fallback configuration trigger: $e");
    }
  }


  Future<void> _checkPermissionsAndStartTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _errorMessage = "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _errorMessage = "Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _errorMessage = "Location permissions permanently denied.");
        return;
      }

      Position initPos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _rawDriverLocation = LatLng(initPos.latitude, initPos.longitude);
          _currentHeading = initPos.heading;
          _isLoading = false;
        });
        _updateDriverMarkerAndCameraPosition();
      }

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ).listen((Position position) {
        if (!mounted) return;

        final LatLng driverLatLng = LatLng(position.latitude, position.longitude);
        _trimTraveledPath(driverLatLng);

        setState(() {
          _rawDriverLocation = driverLatLng;
          _currentHeading = position.heading;
        });

        _updateDriverMarkerAndCameraPosition();
      }, onError: (e) {
        if (mounted) setState(() => _errorMessage = e.toString());
      });

    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    }
  }

  
  Future<void> _fetchAndDrawRoute(LatLng destination) async {
    if (_rawDriverLocation == null) return;
    
    try {
      final String url = "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${_rawDriverLocation!.latitude},${_rawDriverLocation!.longitude}"
          "&destination=${destination.latitude},${destination.longitude}"
          "&key=$_apiKey";
          
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data["status"] == "OK") {
          List<LatLng> detailedCoordinates = [];
          var legs = data["routes"][0]["legs"] as List;
          for (var leg in legs) {
            var steps = leg["steps"] as List;
            for (var step in steps) {
              String stepPolyline = step["polyline"]["points"];
              detailedCoordinates.addAll(_decodePolyline(stepPolyline));
            }
          }

          if (mounted) {
            setState(() {
              _currentRoutePoints = List.from(detailedCoordinates);
              _polylines = {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: _currentRoutePoints,
                  color: const Color(0xFF1E3C72),
                  width: 6,
                  geodesic: true,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                )
              };
            });
          }
        }
      }
    } catch (e) {
      debugPrint("API Directions route calculation error: $e");
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


  void _trimTraveledPath(LatLng driverPos) {
    if (_currentRoutePoints.isEmpty) return;

    int closestIndex = 0;
    double shortestDistance = double.infinity;

    for (int i = 0; i < _currentRoutePoints.length; i++) {
      double distance = _calculateHaversineDistance(driverPos, _currentRoutePoints[i]);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        closestIndex = i;
      }
    }

    if (closestIndex > 0 && shortestDistance < 30.0) {
      _currentRoutePoints = _currentRoutePoints.sublist(closestIndex);
      if (_polylines.isNotEmpty) {
        final existingPolyline = _polylines.first;
        setState(() {
          _polylines = {
            existingPolyline.copyWith(pointsParam: _currentRoutePoints)
          };
        });
      }
    }
  }

  double _calculateHaversineDistance(LatLng p1, LatLng p2) {
    const double earthRadius = 6371000;
    double dLat = (p2.latitude - p1.latitude) * (math.pi / 180.0);
    double dLng = (p2.longitude - p1.longitude) * (math.pi / 180.0);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(p1.latitude * (math.pi / 180.0)) *
            math.cos(p2.latitude * (math.pi / 180.0)) *
            math.sin(dLng / 2) * math.sin(dLng / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }


  void _moveCameraToOffsetPosition(LatLng position, double bearing, bool isTravelling) {
    if (_mapController == null || _isUserInteracting) return;

    LatLng cameraTarget;

    if (isTravelling) {
      final double offsetDistance = 0.0018;
      final double bearingInRadius = bearing * (math.pi / 180);

      final double offsetLat = position.latitude + (offsetDistance * math.cos(bearingInRadius));
      final double offsetLng = position.longitude + (offsetDistance * math.sin(bearingInRadius));
      cameraTarget = LatLng(offsetLat, offsetLng);

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: cameraTarget,
            zoom: 17.5,
            tilt: 45.0,
            bearing: bearing,
          ),
        ),
      );
    } else {
      cameraTarget = position;
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: cameraTarget,
            zoom: 17.5,
            tilt: 0.0,
            bearing: 0.0,
          ),
        ),
      );
    }
  }


  void _startRecenterTimer(bool isTravelling) {
    _recenterTimer?.cancel();
    _recenterTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isUserInteracting = false);
      
      if (_rawDriverLocation != null) {
        _moveCameraToOffsetPosition(_rawDriverLocation!, _currentHeading, isTravelling);
      }
    });
  }


  void _updateDriverMarkerAndCameraPosition() {
    if (_rawDriverLocation == null) return;
    final driverState= ref.read(driverControllerProvider).driver?.driverState;
    final bool isOnline=driverState ==  DriverState.online;
    final trip = ref.read(tripControllerProvider);
    final bool isTravelling = trip != null && (trip.tripState == TripState.onPickup || trip.tripState == TripState.onTrip);
    final bool shouldFollowHeading= isTravelling || isOnline; 
    if (_previousGlidedLocation == null) {
      _previousGlidedLocation = _rawDriverLocation;
      _targetGlidedLocation = _rawDriverLocation;
      _previousHeading = _currentHeading;
      _targetHeading = _currentHeading;

      _renderMarkersLayer(_previousGlidedLocation!, _previousHeading, trip);
      _moveCameraToOffsetPosition(_previousGlidedLocation!, _previousHeading, isTravelling);
      return;
    }

    _previousGlidedLocation = _targetGlidedLocation;
    _targetGlidedLocation = _rawDriverLocation;
    _previousHeading = _targetHeading;
    _targetHeading = _currentHeading;

    _movementController?.reset();
    final Animation<double> curve = CurvedAnimation(parent: _movementController!, curve: Curves.linear);

    _movementController!.clearListeners();
    _movementController!.addListener(() {
      if (!mounted) return;
      final double t = curve.value;

      final double currentLat = _previousGlidedLocation!.latitude +
          (_targetGlidedLocation!.latitude - _previousGlidedLocation!.latitude) * t;
      final double currentLng = _previousGlidedLocation!.longitude +
          (_targetGlidedLocation!.longitude - _previousGlidedLocation!.longitude) * t;
      
      final double currentHeading = _previousHeading + (_targetHeading - _previousHeading) * t;
      final LatLng intermediateLocation = LatLng(currentLat, currentLng);

      _renderMarkersLayer(intermediateLocation, currentHeading, trip);
      _moveCameraToOffsetPosition(intermediateLocation, currentHeading, isTravelling);
    });

    _movementController!.forward();
  }

  void _renderMarkersLayer(LatLng position, double heading, dynamic trip) {
    Set<Marker> localMarkers = {};
    
    if (_customArrowIcon != null) {
      localMarkers.add(
        Marker(
          markerId: const MarkerId("driver_arrow_pointer"),
          position: position,
          icon: _customArrowIcon!,
          anchor: const Offset(0.5, 0.5),
          rotation: heading,
          flat: true,
          zIndex: 1,
        ),
      );
    }

   
    BitmapDescriptor driverIcon = _truckIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    localMarkers.add(
      Marker(
        markerId: const MarkerId("driver_marker"),
        position: position,
        icon: driverIcon,
        anchor: const Offset(0.5, 0.5),
        rotation: heading,
        flat: true,
        zIndex: 2, 
      ),
    );


    if (trip != null) {
      final targetDestination = RouteManager.getTargetDestination(trip);
      if (targetDestination != null) {
        localMarkers.add(
          Marker(
            markerId: MarkerId(trip.tripState == TripState.onPickup ? "pickup" : "drop"),
            position: targetDestination,
            flat: false,
            zIndex: 3,
          ),
        );
      }
    }

    setState(() => _markers = localMarkers);
  }


  void _evalRoutePipelines(dynamic trip) {
    if (trip == null) {
      if (_currentRoutePoints.isNotEmpty) {
        setState(() {
          _currentRoutePoints.clear();
          _polylines.clear();
        });
      }
      _lastProcessedTripId = null;
      _lastProcessedTripState = null;
      return;
    }

    bool shouldRefetch = _lastProcessedTripId != trip.tripId || 
                         _lastProcessedTripState != trip.tripState || 
                         _polylines.isEmpty;

    if (shouldRefetch) {
      _lastProcessedTripId = trip.tripId;
      _lastProcessedTripState = trip.tripState;
      final targetDest = RouteManager.getTargetDestination(trip);
      if (targetDest != null) {
        Future.microtask(() => _fetchAndDrawRoute(targetDest));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripControllerProvider);
    _evalRoutePipelines(trip);

    if (_errorMessage != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ));
    }

    if (_isLoading || _rawDriverLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool isTravelling = trip != null && (trip.tripState == TripState.onPickup || trip.tripState == TripState.onTrip);
    final double initialBearing = _previousHeading;
    
    LatLng initialCameraFocus = _rawDriverLocation!;
    if (isTravelling) {
      final double offsetDistance = 0.0018;
      final double bearingInRadians = initialBearing * (math.pi / 180.0);
      initialCameraFocus = LatLng(
        _rawDriverLocation!.latitude + (offsetDistance * math.cos(bearingInRadians)),
        _rawDriverLocation!.longitude + (offsetDistance * math.sin(bearingInRadians)),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialCameraFocus,
            zoom: 17.5,
            tilt: isTravelling ? 45.0 : 0.0,
            bearing: isTravelling ? initialBearing : 0.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          markers: _markers,
          polylines: _polylines,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.32),
          onMapCreated: (controller) async {
            _mapController = controller;
            try {
              String cleanStyle = await rootBundle.loadString('assets/map_style.json');
              await controller.setMapStyle(cleanStyle);
            } catch (_) {}
            _updateDriverMarkerAndCameraPosition();
          },
          onCameraMoveStarted: () {
            _recenterTimer?.cancel();
            setState(() => _isUserInteracting = true);
          },
          onCameraIdle: () {
            if (_isUserInteracting) {
              _startRecenterTimer(isTravelling);
            }
          },
        ),
        const _BottomTripCardPanel(),
      ],
    );
  }
}

class _BottomTripCardPanel extends ConsumerWidget {
  const _BottomTripCardPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripControllerProvider);
    if (trip == null) return const SizedBox();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Navigation Mode Active",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3C72)),
                ),
                Text(
                  "${trip.rideRequest.distance} km",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(Icons.radio_button_checked_rounded, color: Color(0xFF1E3C72), size: 16),
                    Container(width: 1.5, height: 22, color: Colors.grey.shade200),
                    const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 16),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${trip.rideRequest.pickupAddress.streetLine1}, ${trip.rideRequest.pickupAddress.city}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "${trip.rideRequest.dropAddress.streetLine1}, ${trip.rideRequest.dropAddress.city}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${trip.rideRequest.amount.toStringAsFixed(0)}",
                      style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
            ),
            _buildLifecycleButton(context, ref, trip),
          ],
        ),
      ),
    );
  }

  Widget _buildLifecycleButton(BuildContext context, WidgetRef ref, dynamic trip) {
    final notifier = ref.read(tripControllerProvider.notifier);

    switch (trip.tripState) {
      case TripState.accepted:
        return _buildButton("Start Ride", Icons.navigation_rounded, const Color(0xFF1E3C72), () => notifier.startRide());
      case TripState.onPickup:
        return _buildButton("Arrived at Pickup", Icons.pin_drop_rounded, const Color(0xFFE65100), () => notifier.arrivedAtPickup());
      case TripState.arrived:
        return _buildButton("Start Trip", Icons.play_arrow_rounded, const Color(0xFF2E7D32), () => notifier.startTrip());
      case TripState.onTrip:
        return _buildButton("Complete Trip", Icons.check_circle_rounded, const Color(0xFFC62828), () async {
          String result = await notifier.executeCompleteTripPipeline();
          if (result == 'DOCS_REQUIRED' && context.mounted) {
            _navigateToUploadRequirement(context, trip.tripId, notifier);
          }
        });
      default:
        return const SizedBox();
    }
  }

  void _navigateToUploadRequirement(BuildContext context, int tripId, dynamic notifier) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.note_add_rounded, size: 44, color: Colors.orange),
              const SizedBox(height: 12),
              const Text("Verification Documents Required", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Please upload proof of delivery photo files to complete this trip execution loop.", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3C72),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(modalContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TripUploadScreen(tripId: tripId)),
                    ).then((_) => notifier.executeCompleteTripPipeline());
                  },
                  child: const Text("OPEN UPLOAD PORTAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
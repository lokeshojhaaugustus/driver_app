// lib/location/TechnicalNavigationScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/controller/MapStateController.dart';
import 'package:driver_app/state/TripState.dart';

class TechnicalNavigationScreen extends ConsumerStatefulWidget {
  const TechnicalNavigationScreen({super.key});

  @override
  ConsumerState<TechnicalNavigationScreen> createState() => _TechnicalNavigationScreenState();
}

class _TechnicalNavigationScreenState extends ConsumerState<TechnicalNavigationScreen> {
  GoogleMapController? _navMapController;
  bool _isCameraInitialized = false;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapStateControllerProvider);
    final trip = ref.watch(tripControllerProvider);

    // Safety fallback: if the trip gets cleared or goes null, auto-exit immediately
    if (trip == null || mapState.currentPos == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Continuously lock and animate the 3D tactical camera behind the driver's current position and vector heading
    if (_navMapController != null && mapState.currentPos != null) {
      _navMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: mapState.currentPos!,
            zoom: 18.5,            // High detail street close-up zoom
            tilt: 45.0,            // Tilted 3D perspective orientation view
            bearing: mapState.bearing, // Dynamically maps map alignment to vehicle travel direction
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 🗺️ THE FULL-SCREEN TACTICAL NAVIGATION ENGINE
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: mapState.currentPos!,
              zoom: 18.5,
              tilt: 45.0,
              bearing: mapState.bearing,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            trafficEnabled: true, // Shows real-time traffic updates during navigation routing
            polylines: mapState.polylines,
            markers: _buildNavMarkers(trip, mapState.currentPos, mapState.bearing),
            onMapCreated: (controller) {
              _navMapController = controller;
              // Apply standard dark or navigation map styling if required here
            },
          ),

          // ⬅️ FLOATING BACK BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 🎛️ HUD BOTTOM NAVIGATION DASHBOARD PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dynamic Travel Metrics Indicator HUD Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.navigation_rounded, color: Color(0xFF1E3C72), size: 24),
                          const SizedBox(width: 8),
                          Text(
                            mapState.durationText,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF2E7D32)),
                          ),
                        ],
                      ),
                      Text(
                        mapState.distanceText,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Dynamic Destination Label Row
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: trip.tripState == TripState.onPickup ? const Color(0xFFE65100) : Colors.redAccent, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          trip.tripState == TripState.onPickup
                              ? "Navigating to Pickup: ${trip.pickupAddress.streetLine1}"
                              : "Navigating to Drop-off: ${trip.dropAddress.streetLine1}",
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                  ),

                  // Active State Execution Button Wrapper
                  _buildNavActionButton(context, ref, trip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavActionButton(BuildContext context, WidgetRef ref, dynamic trip) {
    final notifier = ref.read(tripControllerProvider.notifier);
    final mapNotifier = ref.read(mapStateControllerProvider.notifier); // 👈 Grab map notifier reference

    if (trip.tripState == TripState.onPickup) {
      return _buildFullWidthButton("Arrived at Pickup", Icons.pin_drop_rounded, const Color(0xFFE65100), () async {
        if (await notifier.arrivedAtPickup()) {
          if (context.mounted) Navigator.pop(context);
        }
      });
    }

    if (trip.tripState == TripState.onTrip) {
      return _buildFullWidthButton("Complete Trip", Icons.check_circle_rounded, const Color(0xFFC62828), () async {
        
        // 1. Fire the pipeline engine validation step
        String result = await notifier.executeCompleteTripPipeline();
        
        if (result == 'SUCCESS') {
          // ✅ Success! Clear polyline updates
          await mapNotifier.updateRoute();
          if (context.mounted) Navigator.pop(context);
          
        } else if (result == 'DOCS_REQUIRED') {
          // 🛑 Keep it clean: Redirect back to Home Dashboard to handle file picking
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification required! Please complete this trip from the home dashboard screen.'),
                duration: Duration(seconds: 4),
              ),
            );
            Navigator.pop(context); // Return back smoothly to the container holding our upload sheet
          }
        } else {
          // ❌ Fallback handling
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not complete trip. Please check your network connection.')),
            );
          }
        }
      });
    }

    return const SizedBox();
  }

  Widget _buildFullWidthButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 22),
        label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
      ),
    );
  }

  Set<Marker> _buildNavMarkers(dynamic trip, LatLng? currentPos, double bearing) {
    Set<Marker> markers = {};
    if (currentPos == null) return markers;

    markers.add(
      Marker(
        markerId: const MarkerId("driver"),
        position: currentPos,
        rotation: bearing,
        anchor: const Offset(0.5, 0.5),
        flat: true,
      ),
    );

    if (trip.tripState == TripState.onPickup) {
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: LatLng(trip.pickupAddress.latitude, trip.pickupAddress.longitude),
      ));
    } else if (trip.tripState == TripState.onTrip) {
      markers.add(Marker(
        markerId: const MarkerId("drop"),
        position: LatLng(trip.dropAddress.latitude, trip.dropAddress.longitude),
      ));
    }

    return markers;
  }

  @override
  void dispose() {
    _navMapController?.dispose();
    super.dispose();
  }
}
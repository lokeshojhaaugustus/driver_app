// lib/location/MapSection.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/controller/MapStateController.dart';
import 'package:driver_app/state/TripState.dart';
import 'package:driver_app/home/TripUploadScreen.dart'; // Import your existing upload screen layout asset module

class MapSection extends ConsumerWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapStateControllerProvider);
    final trip = ref.watch(tripControllerProvider);

    if (mapState.isCheckingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!mapState.hasPermission) {
      return const Center(child: Text("Location permission denied"));
    }

    if (mapState.currentPos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: mapState.currentPos!,
            zoom: 16.5,
          ),
          myLocationEnabled: false, // Turned off to prevent native blue dot overlays
          myLocationButtonEnabled: false,
          onMapCreated: (controller) async {
            ref.read(mapStateControllerProvider.notifier).googleMapController = controller;
            
            // Apply lightweight customized POI asset filtering style sheet
            try {
              String cleanStyle = await rootBundle.loadString('assets/map_style.json');
              await controller.setMapStyle(cleanStyle);
            } catch (e) {
              debugPrint("Error loading clean style: $e");
            }

            Future.microtask(() {
              ref.read(mapStateControllerProvider.notifier).updateRoute();
            });
          },
          markers: _buildMarkers(trip, mapState.currentPos, ref),
          polylines: mapState.polylines,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.30),
        ),
        const _BottomTripCardPanel(),
      ],
    );
  }

  Set<Marker> _buildMarkers(dynamic trip, LatLng? currentPos, WidgetRef ref) {
    Set<Marker> markers = {};
    if (currentPos == null) return markers;

    final mapState = ref.watch(mapStateControllerProvider);

    // 🌟 DEFAULT LOOK: Blue dot with directional indicator beam
    BitmapDescriptor driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

    // 🔄 LOOK SWAP BASED ON STATE: Move into navigation tracking mode triangle arrow
    if (trip != null) {
      if (trip.tripState == TripState.onPickup || trip.tripState == TripState.onTrip) {
        // High contrast hue representing Google's clean navigation triangle arrow
        driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      }
    }

    markers.add(
      Marker(
        markerId: const MarkerId("driver"),
        position: currentPos,
        icon: driverIcon,
        rotation: mapState.bearing,     // Points icon matching driving vectors
        anchor: const Offset(0.5, 0.5), // Axis center lock formatting
        flat: true,                    // Keeps it aligned to pavement flat lanes
      ),
    );

    if (trip == null) return markers;

    // Target Destination Pins: Configured as standard billboards (flat: false) so they always face up
    if (trip.tripState == TripState.accepted || trip.tripState == TripState.onPickup) {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: LatLng(trip.pickupAddress.latitude, trip.pickupAddress.longitude),
          flat: false, 
        ),
      );
    }

    if (trip.tripState == TripState.arrived || trip.tripState == TripState.onTrip) {
      markers.add(
        Marker(
          markerId: const MarkerId("drop"),
          position: LatLng(trip.dropAddress.latitude, trip.dropAddress.longitude),
          flat: false,
        ),
      );
    }

    return markers;
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
            const SizedBox(height: 16),
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
                        "${trip.pickupAddress.streetLine1}, ${trip.pickupAddress.city}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "${trip.dropAddress.streetLine1}, ${trip.dropAddress.city}",
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
                      "₹${trip.amount.toStringAsFixed(0)}",
                      style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text("${trip.distance} km", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
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
    final mapNotifier = ref.read(mapStateControllerProvider.notifier);

    switch (trip.tripState) {
      case TripState.accepted:
        return _buildButton("Start Ride", Icons.navigation_rounded, const Color(0xFF1E3C72), () async {
          if (await notifier.startRide()) await mapNotifier.updateRoute();
        });
      case TripState.onPickup:
        return _buildButton("Arrived at Pickup", Icons.pin_drop_rounded, const Color(0xFFE65100), () async {
          if (await notifier.arrivedAtPickup()) await mapNotifier.updateRoute();
        });
      case TripState.arrived:
        return _buildButton("Start Trip", Icons.play_arrow_rounded, const Color(0xFF2E7D32), () async {
          if (await notifier.startTrip()) await mapNotifier.updateRoute();
        });
      case TripState.onTrip:
        return _buildButton("Complete Trip", Icons.check_circle_rounded, const Color(0xFFC62828), () async {
          
          // ⚡ Fire updated execution status pipeline check
          String result = await notifier.executeCompleteTripPipeline();
          
          if (result == 'SUCCESS') {
            await mapNotifier.updateRoute();
          } else if (result == 'DOCS_REQUIRED') {
            // 🛑 INTERCEPTED: Open upload controller layout securely
            if (context.mounted) {
              _navigateToUploadRequirement(context, trip.tripId, notifier, mapNotifier);
            }
          } else {
            // Generic Error Alert handler fallback
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not complete trip. Please check connection.')),
              );
            }
          }
        });
      default:
        return const SizedBox();
    }
  }

  // Helper routine displaying explicit requirements modal sheet
  // Helper routine displaying explicit requirements modal sheet
  void _navigateToUploadRequirement(BuildContext context, int tripId, dynamic notifier, dynamic mapNotifier) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      // ⚡ FIX: Allow dynamic resizing bounds to fit various device widths and aspect heights perfectly
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (modalContext) => Padding(
        // ⚡ Ensure it pushes safely above system bottom sheets or navigation bars
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          // ⚡ FIX: Removed hardcoded "height: 240" entirely!
          child: Column(
            // ⚡ FIX: Instruct the column loop to only pack as much space as its children need
            mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.note_add_rounded, size: 44, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                "Verification Documents Required",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please upload proof of delivery photo files to complete this trip execution loop.",
                textAlign: TextAlign.center, // Clearer alignment styling look
              ),
              const SizedBox(height: 24), // Balanced breathing cushion space
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3C72),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(modalContext); // Dismiss bottom sheet
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripUploadScreen(tripId: tripId),
                      ),
                    ).then((_) async {
                      String recheckResult = await notifier.executeCompleteTripPipeline();
                      if (recheckResult == 'SUCCESS') {
                        await mapNotifier.updateRoute();
                      }
                    });
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
import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/controller/RideRequestsController.dart'; // 👈 Your file link
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/riderequest/RideRequestCard.dart';
import 'package:driver_app/service/PushNotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideRequestList extends ConsumerStatefulWidget {
  const RideRequestList({super.key});

  @override
  ConsumerState<RideRequestList> createState() => _RideRequestListState();
}

class _RideRequestListState extends ConsumerState<RideRequestList> {
  bool _isInitLoading = false;

  @override
  void initState() {
    super.initState();
    
    // ⚡ Warm up the sync provider so the notification service gets the 'ref' instance instantly
    ref.read(pushNotificationSyncProvider);

    // Fire off the initial database fetch smoothly on mount
    Future.microtask(() async {
      setState(() => _isInitLoading = true);
      await ref.read(rideRequestsControllerProvider.notifier).loadRideRequests();
      if (mounted) setState(() => _isInitLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ⚡ Listen directly to changes in your provider state list
    final requests = ref.watch(rideRequestsControllerProvider);
    final driverId = ref.watch(driverControllerProvider)?.driverId;

    if (_isInitLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return const Center(
        child: Text(
          "Looking for nearby trips...",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(rideRequestsControllerProvider.notifier).refreshRideRequests(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24, top: 4),
        physics: const BouncingScrollPhysics(), 
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];

          return RideRequestCard(
            rideRequest: request,
            onAccept: () async {
              if (driverId != null) {
                await ref.read(rideRequestsControllerProvider.notifier)
                    .acceptRideRequest(request.rideRequestId, driverId);
              }
            },
            onReject: () async {
              await ref.read(rideRequestsControllerProvider.notifier)
                  .rejectRideRequest(request.rideRequestId);
            },
          );
        },
      ),
    );
  }
}
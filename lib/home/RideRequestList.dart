import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/riderequest/RideRequestCard.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/RideRequestService.dart';
import 'package:driver_app/service/TripService.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:flutter/material.dart';

class RideRequestList extends StatefulWidget {
  const RideRequestList({super.key});

  @override
  State<RideRequestList> createState() => _RideRequestListState();
}

class _RideRequestListState extends State<RideRequestList> {
  List<RideRequest> _requests = [];
  bool _isLoading = true;
  int? _busyRideRequestId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRideRequests();
  }

  Future<void> _loadRideRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final requests = await RideRequestService.getRideRequests();

      if (!mounted) return;

      setState(() {
        _requests = requests;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = "Unable to load ride requests";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptRide(RideRequest request) async {
    final driverId = AppState.currentDriver?.driverId;

    if (driverId == null) {
      return;
    }

    setState(() {
      _busyRideRequestId = request.rideRequestId;
    });

    try {
      final trip = await RideRequestService.acceptRideRequest(request.rideRequestId, driverId);

      if (!mounted) return;

      if (trip != null) {
        AppStateService.setCurrentTrip(trip);
        //TripService.setCurrentTrip(trip);
        DriverStateManager().refresh();
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to accept ride")));
    } finally {
      if (mounted) {
        setState(() {
          _busyRideRequestId = null;
        });
      }
    }
  }

  Future<void> _rejectRide(RideRequest request) async {
    setState(() {
      _busyRideRequestId = request.rideRequestId;
    });

    try {
      await RideRequestService.rejectRideRequest(request.rideRequestId);

      if (!mounted) return;

      setState(() {
        _requests.removeWhere(
          (item) => item.rideRequestId == request.rideRequestId,
        );
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to reject ride")));
    } finally {
      if (mounted) {
        setState(() {
          _busyRideRequestId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_requests.isEmpty) {
      return Center(child: Text("No Ride Requests"));
    }

    return ListView.builder(
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        final request = _requests[index];
        final isBusy = _busyRideRequestId == request.rideRequestId;

        return IgnorePointer(
          ignoring: isBusy,
          child: Opacity(
            opacity: isBusy ? 0.55 : 1,
            child: RideRequestCard(
              rideRequest: request,
              onAccept: () {
                _acceptRide(request);
              },
              onReject: () {
                _rejectRide(request);
              },
            ),
          ),
        );
      },
    );
  }
}

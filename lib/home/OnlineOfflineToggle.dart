import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/controller/TripController.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineOfflineToggle extends ConsumerWidget {
  const OnlineOfflineToggle({super.key});

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref, bool value) async {
    final success = await ref
        .read(driverControllerProvider.notifier)
        .updateDriverState(
          value ? DriverState.online : DriverState.offline,
        );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to update driver state. Check your connection."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverState = ref.watch(driverControllerProvider);
    final isOnline = driverState.driver?.driverState == DriverState.online;
    final isUpdating = driverState.isUpdating;
    final currentTrip = ref.watch(tripControllerProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 2.0),
            child: Text(
              isOnline ? "ONLINE" : "OFFLINE",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isOnline ? Colors.green.shade700 : Colors.grey.shade600,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: isOnline,
              activeColor: Colors.green,
              activeTrackColor: Colors.green.shade200,
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
              onChanged: currentTrip != null || isUpdating
                  ? null
                  : (val) => _toggleStatus(context, ref, val),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/service/AppStateService.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:driver_app/state/DriverStateManager.dart';
import 'package:flutter/material.dart';

class OnlineOfflineToggle extends StatefulWidget {
  const OnlineOfflineToggle({super.key});

  @override
  State<OnlineOfflineToggle> createState() => _OnlineOfflineToggleState();
}

class _OnlineOfflineToggleState extends State<OnlineOfflineToggle> {
  bool _isUpdating = false;


  Future<void> toggleStatus(bool value) async {
    Driver? driver = AppStateService.getCurrentDriver();

    if (driver== null || driver.driverId==null) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    final nextState = value ? DriverState.online : DriverState.offline;

    try {
      final success = await DriverService.updateDriverDetails(driver.driverId!, driver);

      if (!mounted) return;

      if (success) {
        driver.driverState = nextState;
        if (value) {
          DriverStateManager().goOnline();
        } else {
          DriverStateManager().goOffline();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to update driver state")),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to connect to backend")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DriverStateManager(),
      builder: (context, _) {
        final isOnline = DriverStateManager().state == DriverState.online;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOnline ? "ONLINE" : "OFFLINE",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isOnline ? Colors.green : Colors.grey,
                ),
              ),
              Switch(
                value: isOnline,
                onChanged: AppState.currentTrip != null || _isUpdating
                    ? null
                    : toggleStatus,
              ),
            ],
          ),
        );
      },
    );
  }
}

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

  //bool isOnline = DriverStateManager().state == DriverState.online;

  // void toggleStatus(bool value){
  //   setState(() {
  //     isOnline=value;
  //     if(isOnline){
  //       DriverStateManager().setState(DriverState.online);
  //     }
  //     else{
  //       DriverStateManager().setState(DriverState.offline);
  //     }
  //   });
  // }

  void toggleStatus(bool value) {
    if (value) {
      DriverStateManager().goOnline();
    } else {
      DriverStateManager().goOffline();
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DriverStateManager(),
      builder: (context, _) {
        final isOnline = DriverStateManager().state == DriverState.online;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
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
                onChanged: AppState.currentTrip != null 
                  ? null 
                  : (value) {
                  if (value) {
                    DriverStateManager().goOnline();
                  } else {
                    DriverStateManager().goOffline();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
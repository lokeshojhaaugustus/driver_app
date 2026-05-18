import 'package:flutter/material.dart';
import 'package:driver_app/state/DriverState.dart';

class DriverStateManager extends ChangeNotifier {
  static final DriverStateManager _instance = DriverStateManager._internal();

  factory DriverStateManager() => _instance;

  DriverStateManager._internal();

  DriverState _state = DriverState.offline;

  DriverState get state => _state;

  // online
  void goOnline() {
    _state = DriverState.online;
    notifyListeners();
  }

  //offline
  void goOffline() {
    _state = DriverState.offline;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void toggle() {
    if (_state == DriverState.online) {
      goOffline();
    } else {
      goOnline();
    }
  }
}

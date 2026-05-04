import 'package:flutter/material.dart';
import 'package:driver_app/state/DriverState.dart';

class DriverStateManager extends ChangeNotifier{

  static final DriverStateManager _instance=DriverStateManager._internal();

  factory DriverStateManager() {
    return _instance;
  }

  DriverStateManager._internal();

  DriverState _state = DriverState.offline;

  DriverState get state => _state;

  void setState(DriverState newState) {
    _state = newState;
    notifyListeners();
  }


}
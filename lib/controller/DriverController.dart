import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverController extends StateNotifier<Driver?> {
  DriverController() : super(null);

  void setDriver(Driver driver) {
    state = driver;
  }

  void clearDriver() {
    state = null;
  }

  Future<bool> toggleOnlineStatus(bool goOnline) async {
    final targetState = goOnline ? DriverState.online : DriverState.offline;
    return await updateDriverState(targetState);
  }

  Future<bool> updateDriverState(DriverState driverState) async {
    final driver = state;
    if (driver == null || driver.driverId == null) {
      return false;
    }
    final success = await DriverService.updateDriverState(
      driver.driverId!,
      driverState,
    );
    if(!success){
      return false;
    }
    driver.driverState = driverState;
    state=null;
    state = driver;
    return true;
  }
}

final driverControllerProvider = StateNotifierProvider<DriverController, Driver?>(
        (ref) => DriverController(),
  );
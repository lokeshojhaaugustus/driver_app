import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:driver_app/state/DriverState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DriverNotifierState {
  final Driver? driver;
  final bool isUpdating;

  DriverNotifierState({
    this.driver,
    this.isUpdating = false,
  });

  DriverNotifierState copyWith({
    Driver? driver,
    bool? isUpdating,
  }) {
    return DriverNotifierState(
      driver: driver ?? this.driver,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class DriverController extends StateNotifier<DriverNotifierState> {
  DriverController() : super(DriverNotifierState());

  void setDriver(Driver driver) {
    state = state.copyWith(driver: driver);
  }

  void clearDriver() {
    state = DriverNotifierState(driver: null, isUpdating: false);
  }

  Future<bool> toggleOnlineStatus(bool goOnline) async {
    final targetState = goOnline ? DriverState.online : DriverState.offline;
    return await updateDriverState(targetState);
  }

  Future<bool> updateDriverState(DriverState driverState) async {
    final currentDriver = state.driver;
    if (currentDriver == null || currentDriver.driverId == null) {
      return false;
    }

    state = state.copyWith(isUpdating: true);

    try {
      final success = await DriverService.updateDriverState(
        currentDriver.driverId!,
        driverState,
      );
      
      if (!success) {
        state = state.copyWith(isUpdating: false);
        return false;
      }

      currentDriver.driverState = driverState;
      state = DriverNotifierState(driver: currentDriver, isUpdating: false);
      return true;
    } catch (_) {
      state = state.copyWith(isUpdating: false);
      return false;
    }
  }
}


final driverControllerProvider = StateNotifierProvider<DriverController, DriverNotifierState>(
  (ref) => DriverController(),
);
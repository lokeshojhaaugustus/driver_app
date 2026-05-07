import 'package:driver_app/data/TripMockData.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/model/Trip.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:driver_app/state/TripState.dart';

class TripService{

  static Trip? _currentTrip;

  static Trip? get currentTrip => _currentTrip;

  static void createTrip(RideRequest rideRequest, Driver driver){
    final trip = Trip(
      tripId: DateTime.now().millisecondsSinceEpoch,
      rideRequest: rideRequest,
      driver: driver,
      pickupAddress: rideRequest.pickupAddress,
      pickupLocation: rideRequest.pickupLocation,
      dropAddress: rideRequest.dropAddress,
      dropLocation: rideRequest.dropLocation,
      eta: rideRequest.eta,
      amount: rideRequest.amount,
      distance: rideRequest.distance,
      tripState: TripState.onPickup,
      startTime: DateTime.now(),
    );

    _currentTrip = trip;
    AppState.currentTrip=trip;
    TripMockData.trips.add(trip);
  }

  static void arrivedAtPickup(){
    if(_currentTrip!=null){
      _currentTrip!.tripState= TripState.arrived;
    }
  }

  static void startTrip() {
    if (_currentTrip != null) {
      _currentTrip!.tripState = TripState.onTrip;
    }
  }

  static void endTrip() {
    if (_currentTrip != null) {
      _currentTrip!.tripState = TripState.completed;
      _currentTrip!.endTime = DateTime.now();
      _currentTrip = null;
      AppState.currentTrip=null;
    }
  }

  static List<Trip> getTripsByDriverId(int id){
    List<Trip> driverTrips=TripMockData.trips
      .where((t) => t.driver.driverId==id)
      .toList();
    
    return driverTrips;
  }
}
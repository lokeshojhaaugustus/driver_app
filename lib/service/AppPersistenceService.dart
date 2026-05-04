import 'package:shared_preferences/shared_preferences.dart';

class AppPersistenceService {

  static const String driverIdKey = "driverId";
  static const String tripIdKey = "tripId";
  static const String rideIdKey = "rideId";

  // =========================
  // DRIVER
  // =========================

  static Future<void> saveDriver(int driverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(driverIdKey, driverId);
  }

  static Future<int?> getDriver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(driverIdKey);
  }

  static Future<void> clearDriver() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(driverIdKey);
  }

  // =========================
  // TRIP
  // =========================

  static Future<void> saveTrip(int tripId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(tripIdKey, tripId);
  }

  static Future<int?> getTrip() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(tripIdKey);
  }

  static Future<void> clearTrip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tripIdKey);
  }

  // =========================
  // RIDE REQUEST
  // =========================

  static Future<void> saveRide(int rideId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(rideIdKey, rideId);
  }

  static Future<int?> getRide() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(rideIdKey);
  }

  static Future<void> clearRide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(rideIdKey);
  }

  // =========================
  // CLEAR ALL (LOGOUT)
  // =========================

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{

  static const String driverIdKey="driverId";

  static Future<int?> getDriverId() async{
    final prefs= await SharedPreferences.getInstance();
    final driverId= prefs.getInt(driverIdKey);
    print("retrieved driverId from SharedPreferences: $driverId");
    return driverId;
  }

  static Future<void> saveDriverId(int driverId) async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.setInt(driverIdKey, driverId);
    print("saved driverId in SharedPreferences: $driverId");
  }

  static Future<void> removeDriverId() async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.remove(driverIdKey);
    print("removed driverId from SharedPreferences");
  }

}
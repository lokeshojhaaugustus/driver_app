import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{

  static const String driverIdKey="driverId";

  static Future<int?> getDriverId() async{
    final prefs= await SharedPreferences.getInstance();
    return prefs.getInt("driverIdKey");
  }

  static Future<void> saveDriverId(int driverId) async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.setInt(driverIdKey, driverId);
  }

  static Future<void> removeDriverId() async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.remove(driverIdKey);
  }

}
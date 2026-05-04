import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/driverprofile/DriverProfileScreen.dart';
import 'package:driver_app/home/HomeScreen.dart';
import 'package:driver_app/service/AppPersistenceService.dart';
import 'package:driver_app/signup/SignupScreen.dart';
import 'package:driver_app/state/AppState.dart';
import 'package:flutter/material.dart';
//import 'package:driver/screen/HomeScreen.dart';
import 'package:driver_app/login/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final driverId = await AppPersistenceService.getDriver();

  if (driverId != null) {
    // fetch from mock
    final driver = DriverMockData.drivers
        .firstWhere((d) => d.driverId == driverId);

    AppState.currentDriver = driver;

    runApp(MyApp(isLoggedIn: true));
  } else {
    runApp(MyApp(isLoggedIn: false));
  }
}



class MyApp extends StatelessWidget{

  final bool isLoggedIn;

  const MyApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? "/home" : "/login",
      routes: {
        "/login" : (context) => LoginScreen(),
        "/signup" : (context) => SignupScreen(),
        "/home" : (context) => HomeScreen(),
        "/profile" : (context) => DriverProfileScreen()
      },
    );
  }
}

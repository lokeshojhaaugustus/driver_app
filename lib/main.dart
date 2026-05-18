import 'package:driver_app/driverprofile/DriverProfileScreen.dart';
import 'package:driver_app/home/HomeScreen.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/signup/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/login/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn=await SessionService.restoreSession();  
  runApp(MyApp(isLoggedIn: isLoggedIn));
   
}



class MyApp extends StatelessWidget{

  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn
  });

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

import 'package:driver_app/driverprofile/DriverProfileScreen.dart';
import 'package:driver_app/home/HomeScreen.dart';
import 'package:driver_app/home/TripUploadScreen.dart';
import 'package:driver_app/login/LoginScreen.dart';
import 'package:driver_app/otpLogin/OtpVerificationScreen.dart';
import 'package:driver_app/otpLogin/PhoneEmailScreen.dart';
import 'package:driver_app/provider/AppProvider.dart';
import 'package:driver_app/service/AppInitializer.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/signup/SignupScreen.dart';
import 'package:driver_app/testMap/MapTestScreen.dart';
import 'package:driver_app/v1/home/HomeScreenTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {

  
  WidgetsFlutterBinding.ensureInitialized();


  await AppInitializer.runServices(globalNavigatorKey);

  final isLoggedIn = await SessionService.restoreSession();

  runApp(
    UncontrolledProviderScope(
      container: appProviderContainer,
      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey, 
      initialRoute: isLoggedIn ? "/home" : "/initialize",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/home": (context) => const HomeScreen(),
        "/profile": (context) => const DriverProfileScreen(),
        "/uploads": (context) => const TripUploadScreen(tripId: 0), // Placeholder tripId, replace with actual logic
        "/initialize": (context) => const PhoneEmailScreen(),
        "/verify": (context) => const OtpVerificationScreen(email: "", phone: ""),
        "/map": (context) => const MapTestScreen(),
        "/hometest": (context) => const HomeScreenTest()
      },
    );
  }
}